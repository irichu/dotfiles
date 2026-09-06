#!/usr/bin/env bash

# shellcheck source=assets/scripts/lib/apt.sh
source "$(dirname "${BASH_SOURCE[0]}")/../lib/apt.sh"
set -Eeuo pipefail

GNOME_EXTENSIONS_DIR="${GNOME_EXTENSIONS_DIR:-$HOME/.local/share/gnome-shell/extensions}"
GEXT_COMMAND="${GEXT_COMMAND:-$HOME/.local/bin/gext}"
GNOME_EXTENSIONS_COMMAND="${GNOME_EXTENSIONS_COMMAND:-gnome-extensions}"
DOTS_EXTENSION_VERIFY_ATTEMPTS="${DOTS_EXTENSION_VERIFY_ATTEMPTS:-5}"

gnome_extension_is_installed() {
	local extension_id="$1"

	[ -d "$GNOME_EXTENSIONS_DIR/$extension_id" ] && return 0
	"$GNOME_EXTENSIONS_COMMAND" list 2>/dev/null | grep -Fxq "$extension_id"
}

install_one_gnome_extension() {
	local extension_id="$1"
	local output_file attempt

	output_file="$(mktemp "${TMPDIR:-/tmp}/dots-gext.XXXXXX")"
	if "$GEXT_COMMAND" install "$extension_id" >"$output_file" 2>&1; then
		cat "$output_file"
		rm -f -- "$output_file"
		return 0
	fi

	for ((attempt = 1; attempt <= DOTS_EXTENSION_VERIFY_ATTEMPTS; attempt++)); do
		if gnome_extension_is_installed "$extension_id"; then
			printf 'Warning: gext reported an error for %s, but the extension is installed.\n' "$extension_id" >&2
			rm -f -- "$output_file"
			return 0
		fi
		if [ "$attempt" -lt "$DOTS_EXTENSION_VERIFY_ATTEMPTS" ]; then
			sleep 1
		fi
	done

	cat "$output_file" >&2
	printf 'Failed to install GNOME extension: %s\n' "$extension_id" >&2
	rm -f -- "$output_file"
	return 1
}

ubuntu_version_at_least_26_04() {
	local os_release_file="${DOTS_OS_RELEASE_FILE:-/etc/os-release}"
	local version_id os_major os_minor

	[ -r "$os_release_file" ] || return 1
	version_id="$(awk -F= '$1 == "VERSION_ID" { gsub(/"/, "", $2); print $2; exit }' "$os_release_file")"
	IFS='.' read -r os_major os_minor <<<"$version_id"
	[[ "$os_major" =~ ^[0-9]+$ && "${os_minor:-}" =~ ^[0-9]+$ ]] || return 1
	((10#$os_major > 26 || (10#$os_major == 26 && 10#$os_minor >= 4)))
}

install_gnome_extensions() {
	local extension_id schema_path
	local -a extension_ids failed_extensions
	failed_extensions=()

	extension_ids=(
		AlphabeticalAppGrid@stuarthayhurst
		blur-my-shell@aunetx
		compiz-alike-magic-lamp-effect@hermes83.github.com
		compiz-windows-effect@hermes83.github.com
		just-perfection-desktop@just-perfection
		space-bar@luchrioh
		tactile@lundal.io
		tophat@fflewddur.github.io
		undecorate@sun.wxg@gmail.com
		user-theme@gnome-shell-extensions.gcampax.github.com
		wsmatrix@martin.zurowietz.de
	)

	if ubuntu_version_at_least_26_04; then
		extension_ids+=(copyous@boerdereinar.dev)
	fi

	dots_apt_get install -y gnome-shell-extension-manager pipx
	if [ ! -x "$GEXT_COMMAND" ]; then
		pipx install gnome-extensions-cli --system-site-packages
	fi

	for extension_id in "${extension_ids[@]}"; do
		if ! install_one_gnome_extension "$extension_id"; then
			failed_extensions+=("$extension_id (install)")
			continue
		fi

		schema_path="$GNOME_EXTENSIONS_DIR/$extension_id/schemas"
		if [ -d "$schema_path" ]; then
			glib-compile-schemas "$schema_path"
		fi
	done

	# These Ubuntu-provided extensions differ between flavors and releases.
	"$GNOME_EXTENSIONS_COMMAND" enable ubuntu-dock@ubuntu.com || true
	"$GNOME_EXTENSIONS_COMMAND" disable ubuntu-appindicators@ubuntu.com || true
	"$GNOME_EXTENSIONS_COMMAND" enable tiling-assistant@ubuntu.com || true
	"$GNOME_EXTENSIONS_COMMAND" disable ding@rastersoft.com || true

	for extension_id in "${extension_ids[@]}"; do
		if [ ! -d "$GNOME_EXTENSIONS_DIR/$extension_id" ]; then
			printf 'Extension %s not found in %s\n' "$extension_id" "$GNOME_EXTENSIONS_DIR/$extension_id"
			continue
		fi
		if ! "$GNOME_EXTENSIONS_COMMAND" enable "$extension_id"; then
			failed_extensions+=("$extension_id (enable)")
		fi
	done

	mkdir -p "$HOME/.themes" "$HOME/.local/share/icons"

	if [ "${#failed_extensions[@]}" -gt 0 ]; then
		printf 'GNOME extension setup finished with %d failure(s):\n' "${#failed_extensions[@]}" >&2
		printf '  - %s\n' "${failed_extensions[@]}" >&2
		return 1
	fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
	install_gnome_extensions
fi
