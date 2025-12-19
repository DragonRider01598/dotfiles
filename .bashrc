# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
*i*) ;;
*) return ;;
esac

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoredups:erasedups

# append to the history file, don't overwrite it
# check the window size after each command and, if necessary,
shopt -s histappend checkwinsize

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000
export HISTTIMEFORMAT="%F %T "
export HISTIGNORE='ls:cd:cls:exit:history'

echo -ne '\e[6 q'
export TERM=xterm-256color
export COLORTERM=truecolor
export XDG_CONFIG_DIRS=/etc/xdg
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

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

# enable color support of ls
if [ -x /usr/bin/dircolors ]; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

# Default text editor
export EDITOR=vim
export VISUAL=vim

[ -f "$HOME/.bash_funcs" ] && . "$HOME/.bash_funcs"     # load functions
[ -f "$HOME/.bash_aliases" ] && . "$HOME/.bash_aliases" # load aliases

# enable completions
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# lazy load nvm
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"
  nvm "$@"
}

# lazy load pyenv
export PYENV_ROOT="$HOME/.pyenv"
pyenv() {
  unset -f pyenv
  export PATH="$PYENV_ROOT/bin:$PATH"
  command pyenv init --path >/dev/null && eval "$(command pyenv init --path)"
  eval "$(command pyenv init -)"
  pyenv "$@"
}

PROMPT_COMMAND=(
  autoload_nvmrc
  autoload_venv
  "${PROMPT_COMMAND[@]}"
)
export PATH="$HOME/.local/bin:$PATH"

# ctrl + backspace
stty werase \^H
