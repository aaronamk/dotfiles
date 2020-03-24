# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export FILE="lf"
export SUDO_EDITOR=nvim

# Scripts path
typeset -U PATH path
BINPATH="$HOME/.local/bin"
path+=("$BINPATH" ${BINPATH}/*/)
export PATH

export PATH="$HOME/.local/bin:$PATH"

# ~/ Clean-up
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority
export XINITRC=$XDG_CONFIG_HOME/X11/xinitrc
export ZDOTDIR=$XDG_CONFIG_HOME/zsh
export GNUPGHOME=$XDG_CONFIG_HOME/gnupg
export PASSWORD_STORE_DIR=$XDG_CONFIG_HOME/password-store
export PASSWORD_STORE_GENERATED_LENGTH=16
export LESSHISTFILE=$XDG_CONFIG_HOME/lesshst
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export MAYA_APP_DIR=$HOME/wm/2020_spring/maya
