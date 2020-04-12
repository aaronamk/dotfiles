# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export FILE="lf"
export SUDO_EDITOR=nvim

export PASSWORD_STORE_GENERATED_LENGTH=16

# Add scripts path
export PATH="$PATH:$(du "$HOME/.local/bin/" | cut -f2 | tr '\n' ':' | sed 's/:*$//')"

# ~/ cleaning
export XDG_CONFIG_HOME=$HOME/.config
export XINITRC=$XDG_CONFIG_HOME/X11/xinitrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

export XDG_CACHE_HOME=$HOME/.cache
export LESSHISTFILE=$XDG_CACHE_HOME/lesshst

export XDG_DATA_HOME=$HOME/.local/share
export PASSWORD_STORE_DIR=$XDG_DATA_HOME/password-store
export GNUPGHOME=$XDG_DATA_HOME/gnupg

export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority

export MAYA_APP_DIR=$HOME/wm/20_spring/maya
