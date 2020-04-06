#!/bin/bash

selection=$(echo -e "cancel\nLogout\nShut Down\nReboot" | rofi -width -150 -dmenu -i -p "Exit?")

case $selection in
	cancel)
		exit 1
		;;
	"Logout")
		$(pkill -9 -t $(ps $(pgrep Xorg) | grep tty | awk '{print $2}'))
		;;
	"Shut Down")
		$(shutdown now)
		;;
	"Reboot")
		$(systemctl reboot)
		;;
esac
