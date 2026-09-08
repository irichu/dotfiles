#!/usr/bin/env bash

# Sourced by dots. Keep privileged paths fixed; tests replace this function.
dots_rd_paths() {
  rd_config=/etc/rustdesk-server
  rd_data=/var/lib/rustdesk-server
  rd_logs=/var/log/rustdesk-server
  rd_units=/etc/systemd/system
}

dots_rd_error() { printf 'RustDesk: %s\n' "$*" >&2; }

dots_rd_usage() {
  printf '%s\n' \
    'Usage: dots install rustdesk-server --host <IPv4-or-DNS-name>' \
    '       dots setup rustdesk-client --host <IPv4-or-DNS-name> --key <public-key>'
}

# Values enter systemd configuration as well as shell commands. Accept a host,
# not a URL, port, shell expression, or systemd specifier.
dots_rd_host_valid() {
  local host="$1" label octet
  local -a labels
  [ "${#host}" -le 253 ] && [ -n "$host" ] || return 1
  [[ "$host" =~ ^[a-zA-Z0-9.-]+$ ]] && [[ "$host" != *..* ]] || return 1
  host="${host%.}"
  [ -n "$host" ] || return 1
  IFS=. read -r -a labels <<<"$host"
  for label in "${labels[@]}"; do
    [[ "$label" =~ ^[a-zA-Z0-9]([a-zA-Z0-9-]*[a-zA-Z0-9])?$ ]] &&
      [ "${#label}" -le 63 ] || return 1
  done
  if [[ "$host" =~ ^[0-9.]+$ ]]; then
    [ "${#labels[@]}" -eq 4 ] || return 1
    for octet in "${labels[@]}"; do
      [ "${#octet}" -le 3 ] && [ "$((10#$octet))" -le 255 ] || return 1
    done
  fi
}

dots_rd_key_valid() {
  [[ "$1" =~ ^[A-Za-z0-9+/]{43}=$ ]] || return 1
  [ "$(printf '%s' "$1" | base64 -d 2>/dev/null | wc -c)" -eq 32 ]
}

dots_rd_parse() {
  local mode="$1"
  shift
  rd_host='' rd_key=''
  while [ "$#" -gt 0 ]; do
    case "$1" in
    --host)
      [ "$#" -ge 2 ] && [ -z "$rd_host" ] || return 2
      rd_host="$2"; shift 2 ;;
    --key)
      [ "$mode" = client ] && [ "$#" -ge 2 ] && [ -z "$rd_key" ] || return 2
      rd_key="$2"; shift 2 ;;
    *) return 2 ;;
    esac
  done
  dots_rd_host_valid "$rd_host" || return 2
  [ "$mode" != client ] || dots_rd_key_valid "$rd_key" || return 2
}

dots_rd_platform() {
  local ID=
  [ -r /etc/os-release ] || return 1
  . /etc/os-release
  if [ "$ID" != ubuntu ] || [ ! -d /run/systemd/system ]; then
    dots_rd_error 'Ubuntu with a running systemd is required.'
    return 1
  fi
  command -v sudo >/dev/null && command -v dpkg >/dev/null || {
    dots_rd_error 'sudo and dpkg are required.'; return 1;
  }
}

dots_rd_account_valid() {
  local account
  account=$(getent passwd rustdesk) || return 1
  [ "$(printf '%s' "$account" | cut -d: -f6)" = "$rd_data" ] &&
    [[ "$(printf '%s' "$account" | cut -d: -f7)" = */nologin ]] &&
    [ "$(id -gn rustdesk)" = rustdesk ] &&
    [ "$(id -u rustdesk)" -ne 0 ]
}

dots_rd_preflight() {
  local path unit
  if sudo test -f "$rd_config/dots-managed"; then
    [ "$(sudo cat "$rd_config/dots-managed")" = dots-rustdesk-server-v1 ] || {
      dots_rd_error 'Unknown server management marker.'; return 1;
    }
    if getent passwd rustdesk >/dev/null && ! dots_rd_account_valid; then
      dots_rd_error 'The existing rustdesk account has unexpected settings.'; return 1
    fi
    return 0
  fi
  for path in "$rd_config" "$rd_data" "$rd_logs"; do
    if sudo test -e "$path" || sudo test -L "$path"; then
      dots_rd_error "Existing unmanaged server path: $path"; return 1
    fi
  done
  if getent passwd rustdesk >/dev/null || getent group rustdesk >/dev/null ||
    command -v hbbs >/dev/null || command -v hbbr >/dev/null; then
    dots_rd_error 'An unmanaged RustDesk server or rustdesk account already exists.'; return 1
  fi
  for unit in hbbs hbbr; do
    if dpkg-query -W -f='${Status}' "rustdesk-server-$unit" 2>/dev/null | grep -q ' installed$' ||
      [ "$(systemctl show "rustdesk-$unit.service" -p LoadState --value)" != not-found ] ||
      sudo test -e "$rd_units/rustdesk-$unit.service.d"; then
      dots_rd_error "Existing unmanaged rustdesk-$unit service/package."; return 1
    fi
  done
}

dots_rd_download() {
  local arch tag version component name digest url package_version
  arch=$(dpkg --print-architecture) || return 1
  curl --fail --silent --show-error --location --retry 3 \
    https://api.github.com/repos/rustdesk/rustdesk-server/releases/latest \
    -o "$rd_stage/release.json" || return 1
  tag=$(jq -er '.tag_name | select(test("^v?[0-9]+\\.[0-9]+\\.[0-9]+$"))' "$rd_stage/release.json") || return 1
  version="${tag#v}"
  rd_debs=()
  for component in hbbs hbbr; do
    name="rustdesk-server-${component}_${version}_${arch}.deb"
    url="https://github.com/rustdesk/rustdesk-server/releases/download/$tag/$name"
    digest=$(jq -er --arg name "$name" --arg url "$url" \
      '.assets[] | select(.name == $name and .browser_download_url == $url) | .digest | select(test("^sha256:[0-9a-f]{64}$"))' \
      "$rd_stage/release.json") || {
      dots_rd_error "No verified release asset for $name."; return 1;
    }
    curl --fail --silent --show-error --location --retry 3 "$url" -o "$rd_stage/$name" || return 1
    printf '%s  %s\n' "${digest#sha256:}" "$rd_stage/$name" | sha256sum -c - || return 1
    [ "$(dpkg-deb -f "$rd_stage/$name" Package)" = "rustdesk-server-$component" ] &&
      [ "$(dpkg-deb -f "$rd_stage/$name" Architecture)" = "$arch" ] || return 1
    package_version=$(dpkg-deb -f "$rd_stage/$name" Version) || return 1
    dpkg --compare-versions "$package_version" eq "$version" || return 1
    rd_debs+=("$rd_stage/$name")
  done
}

dots_rd_prepare() {
  local component
  sudo install -d -m 755 "$rd_config" || return 1
  printf '%s\n' dots-rustdesk-server-v1 >"$rd_stage/dots-managed" || return 1
  sudo install -m 644 "$rd_stage/dots-managed" "$rd_config/dots-managed" || return 1
  # Remove readiness before apt can run maintainer scripts, including on reruns.
  sudo rm -f -- "$rd_config/dots-ready" || return 1
  for component in hbbr hbbs; do
    if [ "$(systemctl show "rustdesk-$component.service" -p LoadState --value)" != not-found ]; then
      sudo systemctl stop "rustdesk-$component.service" || return 1
    fi
  done
  if ! getent passwd rustdesk >/dev/null; then
    getent group rustdesk >/dev/null || sudo groupadd --system rustdesk || return 1
    sudo useradd --system --gid rustdesk --home-dir "$rd_data" \
      --no-create-home --shell /usr/sbin/nologin rustdesk || return 1
  fi
  dots_rd_account_valid || return 1
  sudo install -d -o rustdesk -g rustdesk -m 700 "$rd_data" "$rd_logs" || return 1
  for component in hbbs hbbr; do
    cat >"$rd_stage/$component.conf" <<EOF || return 1
[Unit]
ConditionPathExists=$rd_config/dots-ready
After=network-online.target
Wants=network-online.target

[Service]
User=rustdesk
Group=rustdesk
WorkingDirectory=$rd_data
UMask=0077
ExecStart=
EOF
    if [ "$component" = hbbs ]; then
      printf 'ExecStart=/usr/bin/hbbs -r %s:21117 -k _\n' "$rd_host" >>"$rd_stage/$component.conf" || return 1
    else
      cat >>"$rd_stage/$component.conf" <<EOF || return 1
ExecStartPre=/usr/bin/test -s $rd_data/id_ed25519
ExecStart=/usr/bin/hbbr -k _

[Unit]
Requires=rustdesk-hbbs.service
After=rustdesk-hbbs.service
EOF
    fi
    sudo install -d -m 755 "$rd_units/rustdesk-$component.service.d" || return 1
    sudo install -m 644 "$rd_stage/$component.conf" \
      "$rd_units/rustdesk-$component.service.d/90-dots.conf" || return 1
  done
  sudo systemctl daemon-reload || return 1
}

dots_rd_start() {
  local component attempt key
  sudo systemctl daemon-reload || return 1
  for component in hbbs hbbr; do
    [ "$(systemctl show "rustdesk-$component.service" -p User --value)" = rustdesk ] &&
      [ "$(systemctl show "rustdesk-$component.service" -p Group --value)" = rustdesk ] || {
      dots_rd_error 'The effective service user/group must be rustdesk.'; return 1;
    }
  done
  sudo touch "$rd_config/dots-ready" || return 1
  sudo systemctl start rustdesk-hbbs.service || return 1
  for ((attempt = 0; attempt < 15; attempt++)); do
    if sudo test -s "$rd_data/id_ed25519" && sudo test -s "$rd_data/id_ed25519.pub"; then
      break
    fi
    sleep 1
  done
  sudo test -s "$rd_data/id_ed25519" || { dots_rd_error 'Server key generation failed.'; return 1; }
  key=$(sudo cat "$rd_data/id_ed25519.pub") || return 1
  dots_rd_key_valid "$key" || { dots_rd_error 'Invalid server public key.'; return 1; }
  sudo chmod 600 "$rd_data/id_ed25519" "$rd_data/id_ed25519.pub" || return 1
  sudo systemctl start rustdesk-hbbr.service || return 1
  sudo systemctl enable rustdesk-hbbs.service rustdesk-hbbr.service || return 1
  systemctl is-active --quiet rustdesk-hbbs.service &&
    systemctl is-active --quiet rustdesk-hbbr.service || return 1
  printf '\nRustDesk Server is running. Public key: %s\n' "$key"
  printf 'On each Ubuntu client, run:\n  dots setup rustdesk-client --host %q --key %q\n' "$rd_host" "$key"
  printf '%s\n' \
    'Allow TCP 21115-21117 and UDP 21116 through your firewall/router as needed.' \
    'Start:   sudo systemctl start rustdesk-hbbs rustdesk-hbbr' \
    'Stop:    sudo systemctl stop rustdesk-hbbr rustdesk-hbbs' \
    'Status:  systemctl status rustdesk-hbbs rustdesk-hbbr' \
    'Logs:    sudo tail /var/log/rustdesk-server/{hbbs,hbbr}.{log,error}'
}

install_rustdesk_server() (
  local rd_host rd_key rd_config rd_data rd_logs rd_units rd_stage rd_preparing=false
  local rd_exit_status=0
  local -a rd_debs
  if [ "${1:-}" = --help ]; then dots_rd_usage; return 0; fi
  dots_rd_parse server "$@" || { dots_rd_usage >&2; return 2; }
  dots_rd_platform || return 1
  dots_rd_paths
  sudo -v || return 1
  dots_rd_preflight || return 1
  if ! command -v curl >/dev/null || ! command -v jq >/dev/null ||
    ! dpkg-query -W -f='${Status}' ca-certificates 2>/dev/null | grep -q ' installed$'; then
    dots_apt_get update && dots_apt_get install -y ca-certificates curl jq || return 1
  fi
  rd_stage=$(mktemp -d) || return 1
  trap 'rd_exit_status=$?
    if [ "$rd_exit_status" -ne 0 ] && [ "$rd_preparing" = true ]; then
      sudo rm -f -- "$rd_config/dots-ready"
      sudo systemctl stop rustdesk-hbbr.service rustdesk-hbbs.service
      dots_rd_error "Setup failed. Keys/data are retained; rerun the same command to retry."
    fi
    rm -rf -- "$rd_stage"' EXIT
  trap 'exit 130' INT
  trap 'exit 143' TERM
  trap 'exit 129' HUP
  dots_rd_download || return 1
  rd_preparing=true
  dots_rd_prepare || return 1
  dots_apt_get install -y "${rd_debs[@]}" || return 1
  dots_rd_start || return 1
)

dots_rd_client_option() {
  sudo timeout 15s rustdesk --option "$@"
}

setup_rustdesk_client() (
  local rd_host rd_key version backup option value actual attempt
  local -a options values
  if [ "${1:-}" = --help ]; then dots_rd_usage; return 0; fi
  dots_rd_parse client "$@" || { dots_rd_usage >&2; return 2; }
  dots_rd_platform || return 1
  if ! dpkg-query -W -f='${Status}' rustdesk 2>/dev/null | grep -q ' installed$' ||
    ! command -v rustdesk >/dev/null; then
    dots_rd_error 'Install the deb client first: dots install rustdesk'; return 1
  fi
  version=$(timeout 15s rustdesk --version) || return 1
  if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] ||
    ! dpkg --compare-versions "$version" ge 1.4.9; then
    dots_rd_error 'RustDesk 1.4.9 or newer is required; update with dots install rustdesk.'; return 1
  fi
  sudo -v || return 1
  printf '%s\n' 'Updating RustDesk network settings may disconnect existing RustDesk sessions.'
  sudo systemctl start rustdesk.service || return 1
  systemctl is-active --quiet rustdesk.service || return 1
  options=(key relay-server api-server custom-rendezvous-server)
  values=("$rd_key" "$rd_host:21117" '' "$rd_host")
  umask 077
  backup="${STATE_DIR:-${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles}/rustdesk"
  mkdir -p "$backup" || return 1
  backup=$(mktemp "$backup/client-options.XXXXXXXX.sh") || return 1
  printf '# Previous RustDesk network settings. Restore with: bash %q\n' "$backup" >"$backup" || return 1
  for option in "${options[@]}"; do
    value=$(dots_rd_client_option "$option") || return 1
    printf 'sudo rustdesk --option %q %q\n' "$option" "$value" >>"$backup" || return 1
  done
  printf 'Previous network settings saved to %s\n' "$backup"
  for ((option = 0; option < ${#options[@]}; option++)); do
    dots_rd_client_option "${options[$option]}" "${values[$option]}" || return 1
  done
  # The upstream CLI can return zero even when settings were not applied.
  for ((attempt = 0; attempt < 10; attempt++)); do
    actual=true
    for ((option = 0; option < ${#options[@]}; option++)); do
      value=$(dots_rd_client_option "${options[$option]}") || return 1
      [ "$value" = "${values[$option]}" ] || actual=false
    done
    if [ "$actual" = true ]; then
      printf 'RustDesk client configured for %s.\n' "$rd_host"
      return 0
    fi
    sleep 1
  done
  dots_rd_error "Settings could not be verified. Previous settings: $backup"
  return 1
)
