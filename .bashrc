# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

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
    PS1="${debian_chroot:+($debian_chroot)}$venv_display\[\033[1;34m\]$folder_display \[\033[1;31m\]>\[\033[0m\] "
# Normal user in home (green > only)
elif [[ "$cwd" == "$HOME" ]]; then
    PS1="${debian_chroot:+($debian_chroot)}$venv_display\[\033[1;32m\]>\[\033[0m\] "
# Normal user elsewhere (folder + green >)
else
    PS1="${debian_chroot:+($debian_chroot)}$venv_display\[\033[1;34m\]$folder_display \[\033[1;32m\]>\[\033[0m\] "
fi
'

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Default text editor
export EDITOR=nano
export VISUAL=nano

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

extract () {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xvjf "$1" ;;
      *.tar.gz)  tar xvzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xvf "$1" ;;
      *.tbz2)    tar xvjf "$1" ;;
      *.tgz)     tar xvzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.Z)       uncompress "$1" ;;
      *.7z)      7z x "$1" ;;
      *)         echo "Don't know how to extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

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
export PROMPT_COMMAND="autoload_nvmrc;$PROMPT_COMMAND"

# Reload shell easily
alias reload='source ~/.bashrc'
