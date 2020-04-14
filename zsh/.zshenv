# Default programs
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="st"
export BROWSER="firefox"
export FILE="lf"
export SUDO_EDITOR=nvim

export PASSWORD_STORE_GENERATED_LENGTH=16

# ~/ cleaning
export XDG_CONFIG_HOME=$HOME/.config
export XINITRC=$XDG_CONFIG_HOME/X11/xinitrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"

export XDG_DATA_HOME=$HOME/.local/share
export PASSWORD_STORE_DIR=$XDG_DATA_HOME/password-store
export GNUPGHOME=$XDG_DATA_HOME/gnupg

export XDG_CACHE_HOME=$HOME/.cache
export LESSHISTFILE=$XDG_CACHE_HOME/lesshst

export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority

export SCRIPTS=$HOME/.local/bin

# Add scripts path
#export PATH="$PATH:$(ls -d $HOME/.local/bin/*/ | tr '\n' ':' | sed 's/\x2F:/:/g' | sed 's/:*$//')"
export PATH="$SCRIPTS:$(ls -d $SCRIPTS/*/ | tr -s '\n' ':' | sed 's/\x2F:/:/g')$PATH"
