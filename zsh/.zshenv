# Default programs
export EDITOR="nvim"
export SUDO_EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="foot"
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
export QT_QPA_PLATFORM="wayland"
export QT_QPA_PLATFORMTHEME="gtk4"
export MOZ_USE_XINPUT2=1
export MOZ_ENABLE_WAYLAND=1
export _JAVA_AWT_WM_NONREPARENTING=1
export SDL_GAMECONTROLLERCONFIG="03000000c82d000010300000110100001172012304,8BitDo Pro 2,platform:Linux,a:b0,b:b1,x:b3,y:b4,back:b10,start:b11,guide:b12,leftshoulder:b6,rightshoulder:b7,leftstick:b13,rightstick:b14,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b8,righttrigger:b9,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,"
# mine
export DATE_FMT="%m/%d/%Y %I:%M:%S %P"

# XDG
export XDG_CURRENT_DESKTOP=River
export XDG_SESSION_DESKTOP=River
export XDG_SESSION_TYPE=wayland
export XDG_DESKTOP_DIR="$HOME/Desktop"
export XDG_DOWNLOAD_DIR="$HOME/Downloads"
export XDG_MUSIC_DIR="$HOME/Music"
export XDG_PICTURES_DIR="$HOME/Pictures"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
# mine
export COMPILED="$HOME/.local/compiled"
export BIN="$HOME/.local/bin"
export WINEPREFIX="$XDG_DATA_HOME/wineprefixes/default"

# ~/ cleaning
export XINITRC="$XDG_CONFIG_HOME/X11/xinitrc"
export GTK2_RC_FILES="$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
export INPUTRC="$XDG_CONFIG_HOME/readline/inputrc"
export WGETRC="$XDG_CONFIG_HOME/wgetrc"
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/config"
export CARGO_HOME="$XDG_DATA_HOME/cargo"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME/password-store"
export GNUPGHOME="$XDG_DATA_HOME/gnupg"
export LESSHISTFILE="$XDG_CACHE_HOME/lesshst"
export XAUTHORITY="$XDG_RUNTIME_DIR/Xauthority"

# Add scripts to path
export PATH="$BIN:$(ls -d $BIN/*/ | tr -s '\n' ':' | sed 's/\x2F:/:/g')$PATH"
