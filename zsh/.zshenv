# Default programs
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"
export FILE="vifm"

# Settings
export MAKEFLAGS="-j$(expr $(nproc) \+ 1)"
export LC_ALL=en_US.UTF-8
export GTK_THEME=Material-Black-Lime-4.0
export PASSWORD_STORE_GENERATED_LENGTH=16
export FZF_DEFAULT_OPTS="--reverse --bind=tab:down,btab:up,change:top"
export FZF_DEFAULT_COMMAND="rg --files --ignore --hidden --glob=!.git"
export CM_LAUNCHER=fzf
export CM_HISTLENGTH=8
export QT_QPA_PLATFORMTHEME="gtk2"
export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1
# mine
export DATE_FMT="%m/%d/%Y %I:%M:%S %P"

# Locations
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_CONFIG_HOME=$HOME/.config
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CACHE_HOME=$HOME/.cache
# mine
export COMPILED=$HOME/.local/compiled
export SCRIPTS=$HOME/.local/bin

# ~/ cleaning
export XINITRC=$XDG_CONFIG_HOME/X11/xinitrc
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/config"
export PASSWORD_STORE_DIR=$XDG_DATA_HOME/password-store
export GNUPGHOME=$XDG_DATA_HOME/gnupg
export LESSHISTFILE=$XDG_CACHE_HOME/lesshst
export XAUTHORITY=$XDG_RUNTIME_DIR/Xauthority

# Add scripts to path
export PATH="$SCRIPTS:$(ls -d $SCRIPTS/*/ | tr -s '\n' ':' | sed 's/\x2F:/:/g')$PATH"
