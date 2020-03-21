#!/bin/bash

desktop=$(wmctrl -d | grep ":" | cut -c 1)

if [[ ! -z $desktop ]] && [[ $(wmctrl -l | awk "\$2 == $desktop" | grep "·") && -n "$(wmctrl -d | grep ":")" ]]; then
	raw=$(wmctrl -l | awk "\$2 == $desktop" | cut -d " " -f 5-)
	echo "${raw:0:${#raw}-18}"
fi
