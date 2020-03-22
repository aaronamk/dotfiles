typeset -U PATH path
BINPATH="$HOME/.local/bin"
path+=("$BINPATH" ${BINPATH}/*/)
export PATH

export PATH="$HOME/.local/bin:$PATH"
export ZDOTDIR="$HOME/.config/zsh"
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export FILE="lf"
export SUDO_EDITOR=nvim
export XDG_CONFIG_HOME=~/.config
export GNUPGHOME=~/.config/gnupg
export PASSWORD_STORE_DIR=~/.config/password-store
export PASSWORD_STORE_GENERATED_LENGTH=16
export LESSHISTFILE=$HOME/.config/lesshst
export MAYA_APP_DIR=~/wm/2020_spring/maya
