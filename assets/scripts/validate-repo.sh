#!/usr/bin/env bash

set -Eeuo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$repo_root"

mapfile -t shell_files < <(find . -type f \( -name '*.sh' -o -name '*.bash' \) -not -path './.git/*' | sort)
for file in "${shell_files[@]}"; do
  if grep -q $'\r$' "$file"; then
    tr -d '\r' <"$file" | bash -n
  else
    bash -n "$file"
  fi
done

if command -v zsh >/dev/null 2>&1; then
  while IFS= read -r file; do
    if grep -q $'\r$' "$file"; then
      tr -d '\r' <"$file" | zsh -n
    else
      zsh -n "$file"
    fi
  done < <(find . -type f -name '*.zsh' -not -path './.git/*' | sort)
fi

if command -v shellcheck >/dev/null 2>&1; then
  # The legacy command module still has a warning backlog; errors remain release-blocking.
  shellcheck --severity=error install.sh assets/scripts/main.sh assets/scripts/lib/*.sh assets/scripts/desktop/flatpak/*.sh assets/scripts/dots-test.sh assets/scripts/docker-test.sh
fi

while IFS= read -r link; do
  target="$(readlink "$link")"
  if [[ "$target" = /* ]]; then
    resolved="$target"
  else
    resolved="$(dirname "$link")/$target"
  fi
  [ -e "$resolved" ] || {
    echo "Broken repository symlink: $link -> $target" >&2
    exit 1
  }
done < <(find config -type l -print)

grep -Fq 'assets/scripts/completions/compdef_dots.zsh' config/zsh/completions/_dots || {
  echo "The _dots entrypoint does not load the canonical completion" >&2
  exit 1
}

echo "Repository validation passed."
