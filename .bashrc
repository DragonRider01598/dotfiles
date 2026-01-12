# ~/.bashrc — interactive only
[[ $- != *i* ]] && return

# === HISTORY ===
HISTCONTROL=ignoredups:erasedups
HISTSIZE=1000
HISTFILESIZE=2000
HISTTIMEFORMAT="%F %T "
HISTIGNORE='ls:cd:cls:exit:history'
shopt -s histappend checkwinsize

# === NAVIGATION ===
shopt -s autocd cdspell

# === TERMINAL ===
echo -ne '\e[6 q'
export TERM=xterm-256color
export COLORTERM=truecolor
export XDG_CONFIG_DIRS=/etc/xdg
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# === ENVIRONMENT ===
export EDITOR=vim
export VISUAL=vim
export PATH="$HOME/.local/bin:$PATH"

# === PROMPT COLORS ===
C_RESET='\[\033[0m\]'
C_BLUE='\[\033[1;34m\]'
C_GREEN='\[\033[1;32m\]'
C_RED='\[\033[1;31m\]'
C_GREY='\[\033[0;37m\]'

# === PROMPT ===
__prompt_build() {
  local status=$?
  local cwd=${PWD/#$HOME/~}
  local basename=${cwd##*/}
  local fail=""
  local venv=""

  ((status != 0)) && fail="${C_RED}✗ ${C_RESET}"
  [[ -n $VIRTUAL_ENV ]] && venv="${C_GREY}(${VIRTUAL_ENV##*/}) ${C_RESET}"

  if [[ $cwd == "~" ]]; then
    PS1="${fail}${venv}${C_GREEN}>${C_RESET} "
  elif ((EUID == 0)); then
    PS1="${fail}${venv}${C_BLUE}${basename} ${C_RED}>${C_RESET} "
  else
    PS1="${fail}${venv}${C_BLUE}${basename} ${C_GREEN}>${C_RESET} "
  fi
}

PROMPT_COMMAND=__prompt_build

# === COLORS FOR LS ===
if command -v dircolors >/dev/null; then
  eval "$(dircolors -b ~/.dircolors 2>/dev/null || dircolors -b)"
fi

# === FUNCTIONS & ALIASES ===
[[ -f ~/.bash_funcs ]] && source ~/.bash_funcs
[[ -f ~/.bash_aliases ]] && source ~/.bash_aliases

# === COMPLETIONS ===
if ! shopt -oq posix; then
  [[ -f /usr/share/bash-completion/bash_completion ]] &&
    source /usr/share/bash-completion/bash_completion
fi

# === LAZY LOADERS ===
export NVM_DIR="$HOME/.nvm"
nvm() {
  unset -f nvm
  source "$NVM_DIR/nvm.sh" 2>/dev/null
  source "$NVM_DIR/bash_completion" 2>/dev/null
  nvm "$@"
}

export PYENV_ROOT="$HOME/.pyenv"
pyenv() {
  unset -f pyenv
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(command pyenv init --path 2>/dev/null)"
  eval "$(command pyenv init - 2>/dev/null)"
  pyenv "$@"
}

# === PROMPT HOOKS (SAFE APPEND) ===
PROMPT_COMMAND=(
  autoload_nvmrc
  autoload_venv
  "$PROMPT_COMMAND"
)

# === INPUT ===
stty werase '^H'
