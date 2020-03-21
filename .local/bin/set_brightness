#!/bin/bash


case $1 in
	"+")
		$(brightnessctl set 70+)
		;;
	"-")
		$(brightnessctl set 69\-)
		;;
esac

if [[ -n $(xrandr --listactivemonitors | grep "DP1 2560") ]]; then
	brightness=$(brightnessctl -d intel_backlight g)

	$(ddcutil --bus=5 setvcp 10 $((brightness / 10 - 8)))
fi
