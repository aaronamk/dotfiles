#!/bin/bash

ws="$(wmctrl -d | grep "*" | awk -F'  ' '{print $5}') "
new="$(rofi -dmenu -p 'Rename Workspace' -filter "${ws:2:-1}") "
if [[ ${#new} == 1 ]]; then
	msg=${ws}
else
	msg='rename workspace to "'${new:0:1}':'${new:0:1}':'${new:2:-1}'"'
fi
$(i3-msg $msg)
