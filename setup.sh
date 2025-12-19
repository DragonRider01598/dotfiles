#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="$HOME/.local/bin"
DOTFILES_BIN="$DOTFILES_DIR/bin"

declare -A FILES_TO_COPY=(
  [".bashrc"]="$HOME/.bashrc"
  [".bash_aliases"]="$HOME/.bash_aliases"
  [".bash_funcs"]="$HOME/.bash_funcs"
  [".vimrc"]="$HOME/.vimrc"
)

copy_with_diff() {
  local src="$1"
  local dest="$2"
  local make_executable="${3:-false}"

  if [[ ! -f "$src" ]]; then
    echo "Warning: $src not found — skipping."
    return
  fi

  if [[ -f "$dest" ]]; then
    if cmp -s "$src" "$dest"; then
      echo "Identical: $dest — skipping."
      return
    fi

    echo "Difference detected in: $dest"
    diff --color=always -u "$dest" "$src" || true
    echo
    read -rp "Overwrite $dest? [y/N]: " confirm
    [[ "$confirm" =~ ^[yY]$ ]] || {
      echo "Skipped: $dest"
      return
    }
  fi

  cp "$src" "$dest"

  if [[ "$make_executable" == "true" ]]; then
    chmod +x "$dest"
  fi

  if [[ -f "$dest" ]]; then
    echo "Installed: $dest"
  else
    echo "Copied: $src → $dest"
  fi
}

echo "Setting up local dotfiles from: $DOTFILES_DIR"
echo

for file in "${!FILES_TO_COPY[@]}"; do
  copy_with_diff \
    "$DOTFILES_DIR/$file" \
    "${FILES_TO_COPY[$file]}"
done

echo
echo "✔ Dotfile setup complete."

echo
echo "Setting up local bin scripts from: $DOTFILES_BIN"
echo

mkdir -p "$LOCAL_BIN"

for script in "$DOTFILES_BIN"/*; do
  [[ -f "$script" ]] || continue
  copy_with_diff \
    "$script" \
    "$LOCAL_BIN/$(basename "$script")" \
    true
done

echo
echo "✔ Local bin setup complete."
