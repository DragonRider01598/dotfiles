#!/bin/bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOCAL_BIN="$HOME/.local/bin"
DOTFILES_BIN="$DOTFILES_DIR/bin"

declare -A FILES_TO_COPY=(
    ["vimrc"]="$HOME/.vimrc"
)

declare -A DIRS_TO_COPY=(
    ["vim"]="$HOME/.vim"
    ["yazi"]="$HOME/.config/yazi"
    ["tmux"]="$HOME/.config/tmux"
)

copy_with_diff() {
  local src="$1"
  local dest="$2"
  local make_executable="${3:-false}"

  if [[ ! -f "$src" ]]; then
    echo "Warning: $src not found — skipping."
    return
  fi

  local dest_dir
  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"

  if [[ -f "$dest" ]]; then
    if cmp -s "$src" "$dest"; then
      echo "Identical: $dest — skipping."
      return
    fi

    echo "Difference detected in: $dest"
    diff -u "$dest" "$src" || true
    echo
    echo -n "Overwrite $dest? [y/N]: "
    read -r confirm
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

printf "Select your shell configuration preference [bash/zsh/skip]\n[1-3 or Enter]: "
read -r shell_choice

case "$shell_choice" in
  1|[Bb][Aa][Ss][Hh])
    echo "-> Queueing Bash configurations..."
    for file in bashrc bash_aliases bash_funcs; do
      FILES_TO_COPY["bash/$file"]="$HOME/.${file}"
    done
    ;;
  2|[Zz][Ss][Hh])
    echo "-> Queueing Zsh configurations..."
    for file in zshrc zsh_aliases zsh_funcs; do
      FILES_TO_COPY["zsh/$file"]="$HOME/.${file}"
    done
    ;;
  *)
    echo "-> Skipping shell configuration."
    ;;
esac

echo "Setting up local dotfiles from: $DOTFILES_DIR"
echo

for file in "${!FILES_TO_COPY[@]}"; do
  copy_with_diff \
    "$DOTFILES_DIR/$file" \
    "${FILES_TO_COPY[$file]}"
done

echo "Setting up configuration directories..."
for dir_key in "${!DIRS_TO_COPY[@]}"; do
  src_dir="$DOTFILES_DIR/$dir_key"
  dest_dir="${DIRS_TO_COPY[$dir_key]}"

  if [[ -d "$src_dir" ]]; then
    mkdir -p "$dest_dir"

    for src_file in "$src_dir"/*; do
      filename=$(basename "$src_file")
      dest_file="$dest_dir/$filename"

      copy_with_diff "$src_file" "$dest_file"
    done
  else
    echo "Warning: $src_dir not found — skipping $dir_key modules."
  fi
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
