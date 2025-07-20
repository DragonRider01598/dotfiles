#!/bin/bash

# Get the directory where this script is located (your dotfiles folder)
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Config files to copy: [source in dotfiles] => [destination in home]
declare -A FILES_TO_COPY=(
  [".bashrc"]="$HOME/.bashrc"
  [".bash_aliases"]="$HOME/.bash_aliases"
  [".vimrc"]="$HOME/.vimrc"
)

echo "Setting up local dotfiles from: $DOTFILES_DIR"
echo

copy_files() {
  local src="$1"
  local dest="$2"

  if [[ ! -f "$src" ]]; then
    echo "Warning: $src not found in dotfiles."
    return
  fi

  if [[ -f "$dest" ]]; then
    if cmp -s "$src" "$dest"; then
      echo "Identical: $dest — skipping."
      return
    else
      echo "Difference detected in: $dest"
      diff --color=always -u "$dest" "$src" || true
      echo
      read -rp "Overwrite $dest with $src? [y/N]: " confirm
      if [[ "$confirm" =~ ^[yY]$ ]]; then
        cp "$src" "$dest"
        echo "Copied: $src → $dest"
      else
        echo "Skipped: $dest"
      fi
    fi
  else
    cp "$src" "$dest"
    echo "Copied: $src → $dest (new file)"
  fi
}

# Process each file
for file in "${!FILES_TO_COPY[@]}"; do
  src="$DOTFILES_DIR/$file"
  dest="${FILES_TO_COPY[$file]}"
  copy_files "$src" "$dest"
done

echo
echo "Dotfile setup complete. Restart your terminal or run: source ~/.bashrc"