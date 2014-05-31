setopt autocd completeinword correct extendedglob extendedhistory \
       incappendhistory interactivecomments nobeep noclobber promptsubst \
       pushdsilent sharehistory

HISTFILE=$HOME/.zsh_history
SAVEHIST=1000000
HISTSIZE=1000000

export CLICOLOR=1
export LSCOLORS=gxGxFxdxbxDxDxBxBxExEx
export EDITOR=vim

bindkey -v
bindkey '\e[3~' delete-char
bindkey '^R' history-incremental-search-backward

alias g="git"
alias gg="git grep"
alias gc="git checkout"
alias gcm="git checkout master"
alias gb="git branch"
alias gd="git diff"
alias gdm="git diff master"
alias gm="git merge"
alias gmm="git merge master"
alias gs="git status"
alias gp="git pull"

alias -g L='| less'
alias -g C='| wc -l'

# cd with no arguments to root if in a git repo
_git_cd() {
  if [[ "$1" != "" ]]; then
    cd "$@"
  else
    local OUTPUT
    OUTPUT="$(git rev-parse --show-toplevel 2>/dev/null)"
    if [[ -e "$OUTPUT" ]]; then
      if [[ "$OUTPUT" != "$(pwd -P)" ]]; then
        cd "$OUTPUT"
      else
        cd
      fi
    else
      cd
    fi
  fi
}

if command -v git >/dev/null; then
  alias cd=_git_cd
fi

case `uname` in
  FreeBSD)
    alias ls='gnuls --color=auto -GF'
  ;;
  NetBSD)
    alias ls='ls -F'
  ;;
  OpenBSD)
    alias ls='ls -F'
  ;;
  Linux)
    alias ls='ls --color=always -F'
  ;;
  Darwin)
    alias ls='ls -GF'
  ;;
esac

alias vi='vim'

autoload -U compinit && compinit
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' menu select
zstyle ':completion:*' squeeze-slashes true

autoload -U colors && colors

# Remove prompt on line paste
nbsp=$'\u00A0'
bindkey -s $nbsp '^u'
PROMPT='%(1j.%j& .)%c%F{black}/%f%b$(_git_head) %(?.%F{green}.%F{red})%#%f$nbsp'

_git_head() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "%F{blue}${ref#refs/heads/}%f"
}

if [[ -f $HOME/.zshrc.local ]]; then
  . $HOME/.zshrc.local
fi
