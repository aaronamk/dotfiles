xmodmap /home/ak/.config/Xmodmap/config &
xbanish &
sxhkd &
xss-lock -- i3lock -n -u -c 1c69b1 -i ~/pictures/backgrounds/blue_screen.png &
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
~/.config/polybar/launch.sh
export SSH_AUTH_SOCK &
xcape -e 'Control_L=Escape;Hyper_R=Tab' &

exec bspwm
