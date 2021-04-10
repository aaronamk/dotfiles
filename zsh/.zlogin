# if on tty1, start the X server
[ -z $DISPLAY ] && [ $(tty) = /dev/tty1 ] && sx
