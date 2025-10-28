# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoredups:erasedups

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

echo -ne '\e[6 q'

export TERM=xterm-256color
export COLORTERM=truecolor
export XDG_CONFIG_DIRS=/etc/xdg
PROMPT_COMMAND='
cwd=$(pwd)
basename=$(basename "$cwd")
parent=$(dirname "$cwd")

# Get venv name (basename of VIRTUAL_ENV path), if any
if [[ -n "$VIRTUAL_ENV" ]]; then
    venv_name=$(basename "$VIRTUAL_ENV")
    venv_display="\[\033[0;37m\]($venv_name) \[\033[0m\]"  # grey
else
    venv_display=""
fi

# Show ❯ before folder name if nested, else just folder name or empty if in home
if [[ "$cwd" == "$HOME" ]]; then
    folder_display=""
elif [[ "$parent" == "/" || "$parent" == "$HOME" ]]; then
    folder_display="$basename"
else
    folder_display="❯ $basename"
fi

# Root user prompt (red >)
if [[ $EUID -eq 0 ]]; then
    PS1="$venv_display\[\033[1;34m\]$folder_display \[\033[1;31m\]>\[\033[0m\] "
# Normal user in home (green > only)
elif [[ "$cwd" == "$HOME" ]]; then
    PS1="$venv_display\[\033[1;32m\]>\[\033[0m\] "
# Normal user elsewhere (folder + green >)
else
    PS1="$venv_display\[\033[1;34m\]$folder_display \[\033[1;32m\]>\[\033[0m\] "
fi
'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Default text editor
export EDITOR=vim
export VISUAL=vim

# Alias definitions.
# You may want to put all your additions into a separate file like\
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# --- Fix permission issues with Windows-mounted files ---
fixperms() {
  sudo find . -type f -exec chmod 644 {} \;
  sudo find . -type d -exec chmod 755 {} \;
  echo "Permissions fixed (644 for files, 755 for directories)"
}

extract() {
  if [ $# -eq 0 ]; then
    echo "Usage: extract <file1> [file2 ...]"
    return 1
  fi

  for archive in "$@"; do
    if [ ! -f "$archive" ]; then
      echo "Error: '$archive' is not a valid file."
      continue
    fi

    case "$archive" in
    *.tar.bz2 | *.tbz2) tar xvjf "$archive" ;;
    *.tar.gz | *.tgz) tar xvzf "$archive" ;;
    *.tar.xz) tar --xz -xvf "$archive" ;;
    *.tar.zst) tar --zstd -xvf "$archive" ;;
    *.tar.lzma) tar --lzma -xvf "$archive" ;;
    *.tar) tar xvf "$archive" ;;
    *.bz2) bunzip2 "$archive" ;;
    *.gz) gunzip "$archive" ;;
    *.xz) unxz "$archive" ;;
    *.lzma) unlzma "$archive" ;;
    *.zst) unzstd "$archive" ;;
    *.zip) unzip "$archive" ;;
    *.rar) unrar x "$archive" ;;
    *.7z) 7z x "$archive" ;;
    *.cab) cabextract "$archive" ;;
    *.cpio) cpio -id <"$archive" ;;
    *.Z) uncompress "$archive" ;;
    *.ar) ar x "$archive" ;;
    *) echo "Cannot extract '$archive' — unknown format." ;;
    esac
  done
}

# unrar p7zip-full cabextract xz-utils zstd lzma

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

autoload_nvmrc() {
  if [[ -f .nvmrc ]]; then
    local node_version=$(<.nvmrc)
    if [[ "$(nvm current)" != "v$node_version" ]]; then
      nvm use &>/dev/null
    fi
  fi
}

autoload_venv() {
  local venv_path=""
  if [[ -f ".venv/bin/activate" ]]; then
    venv_path="$(realpath .venv)"
  elif [[ -f "venv/bin/activate" ]]; then
    venv_path="$(realpath venv)"
  fi

  if [[ -n "$venv_path" ]]; then
    if [[ "$VIRTUAL_ENV" != "$venv_path" ]]; then
      [ -n "$VIRTUAL_ENV" ] && deactivate 2>/dev/null
      source "$venv_path/bin/activate"
    fi
  else
    # If no venv found, but one is active, deactivate
    [[ -n "$VIRTUAL_ENV" ]] && deactivate 2>/dev/null
  fi
}
export HISTTIMEFORMAT="%F %T "
export HISTIGNORE='ls:cd:cls:exit:history'
export PROMPT_COMMAND="autoload_nvmrc; autoload_venv; $PROMPT_COMMAND"

# Reload shell easily
alias reload='source ~/.bashrc'

# ctrl + backspace
stty werase \^H

# --- Initialize pyenv only when NOT in a virtual environment ---
if [[ -z "$VIRTUAL_ENV" ]]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"

  if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init --path)"
    eval "$(pyenv init -)"
  fi
fi

# --- When inside a venv, make sure its bin/ is before pyenv shims ---
if [[ -n "$VIRTUAL_ENV" ]]; then
  PATH="$VIRTUAL_ENV/bin:$PATH"
  PATH=$(echo "$PATH" | tr ':' '\n' | grep -v "$HOME/.pyenv/shims" | paste -sd ':' -)
  export PATH
fi

# -- sdkman support for java environments --
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
