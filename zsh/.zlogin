[ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && startx $XDG_CONFIG_HOME/X11/xinitrc
