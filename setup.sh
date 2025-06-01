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
sudo apt install -y git curl neovim build-essential

echo "Installing nvm..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

echo "Setting up dotfiles from $DOTFILES_DIR ..."

echo "Linking .bashrc and .bash_aliases to home directory..."
ln -sf "$DOTFILES_DIR/.bashrc" ~/.bashrc
ln -sf "$DOTFILES_DIR/.bash_aliases" ~/.bash_aliases

if [[ "$MODE" == "local" ]]; then
  echo "Linking Neovim config locally (~/.config/nvim)..."
  mkdir -p ~/.config/nvim
  ln -sf "$DOTFILES_DIR/init.vim" ~/.config/nvim/init.vim
else
  echo "Linking Neovim config globally (/etc/xdg/nvim)..."
  sudo mkdir -p /etc/xdg/nvim
  sudo ln -sf "$DOTFILES_DIR/init.vim" /etc/xdg/nvim/init.vim
fi

echo "Setup complete! Please restart your terminal or run 'source ~/.bashrc'"
