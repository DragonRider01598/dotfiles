#!/bin/bash

# Get the directory where this script is located (the dotfiles folder)
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Usage function
usage() {
  echo "Usage: $0 [local|global]"
  echo "  local  - Link configs to user home directory (default)"
  echo "  global - Link Neovim config globally to /etc/xdg/nvim (requires sudo)"
  exit 1
}

# Check argument
MODE=${1:-local}

if [[ "$MODE" != "local" && "$MODE" != "global" ]]; then
  usage
fi

echo "Updating and upgrading apt..."
sudo apt update && sudo apt upgrade -y 
# make sure neovim supports lua
sudo apt install -y git curl neovim build-essential

echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

echo "Setting up dotfiles from $DOTFILES_DIR ..."

echo "Linking .bashrc and .bash_aliases to home directory..."
ln -sf "$DOTFILES_DIR/.bashrc" ~/.bashrc
ln -sf "$DOTFILES_DIR/.bash_aliases" ~/.bash_aliases

# === Paths ===
if [[ "$MODE" == "local" ]]; then
  CONFIG_DIR="$HOME/.config/nvim"
  LAZY_DIR="$HOME/.local/share/nvim/lazy/lazy.nvim"
else
  CONFIG_DIR="/etc/xdg/nvim"
  LAZY_DIR="/usr/local/share/nvim/lazy/lazy.nvim"
fi

# === Install lazy.nvim ===
if [ ! -d "$LAZY_DIR" ]; then
  echo "Installing lazy.nvim to $LAZY_DIR ..."
  if [[ "$MODE" == "local" ]]; then
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git "$LAZY_DIR"
  else
    sudo git clone --filter=blob:none https://github.com/folke/lazy.nvim.git "$LAZY_DIR"
  fi
else
  echo "lazy.nvim already exists at $LAZY_DIR"
fi

# === Link init.lua ===
echo "Linking init.lua to $CONFIG_DIR ..."
if [[ "$MODE" == "local" ]]; then
  mkdir -p "$CONFIG_DIR"
  ln -sf "$DOTFILES_DIR/init.lua" "$CONFIG_DIR/init.lua"
else
  sudo mkdir -p "$CONFIG_DIR"
  sudo ln -sf "$DOTFILES_DIR/init.lua" "$CONFIG_DIR/init.lua"
fi

echo "Setup complete! Please restart your terminal or run 'source ~/.bashrc'"
