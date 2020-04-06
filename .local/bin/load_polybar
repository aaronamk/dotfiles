#!/bin/bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
#while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar, using default config location ~/.config/polybar/config
#polybar bottom
monitors=$(polybar --list-monitors | grep "DP1: 2560x1440")
if [[ $(polybar --list-monitors | grep "DP1: 2560x1440" | wc -l) == 1 ]]; then
	MONITOR=DP1 polybar --reload bottom &
	MONITOR=eDP1 polybar --reload secondary &
else
	MONITOR=eDP1 polybar --reload bottom &
fi
