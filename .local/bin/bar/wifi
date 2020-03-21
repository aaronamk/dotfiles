#!/bin/bash
# Copyright (C) 2014 Alexander Keller <github@nycroth.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

#------------------------------------------------------------------------
if [[ -z "$INTERFACE" ]] ; then
    INTERFACE="${BLOCK_INSTANCE:-wlan0}"
fi
#------------------------------------------------------------------------

# As per #36 -- It is transparent: e.g. if the machine has no battery or wireless
# connection (think desktop), the corresponding block should not be displayed.
[[ ! -d /sys/class/net/${INTERFACE}/wireless ]] && exit

# If the wifi interface exists but no connection is active, "down" shall be displayed.
if [[ "$(cat /sys/class/net/$INTERFACE/operstate)" = 'down' ]]; then
    echo " down"
    echo " down"
    echo "#FF0000"
    exit
fi

#------------------------------------------------------------------------

QUALITY=$(grep $INTERFACE /proc/net/wireless | awk '{ print int($3 * 100 / 70) }')

#------------------------------------------------------------------------


#------------------------------------------------------------------------

ESSID=$(/sbin/iwconfig $INTERFACE | perl -n -e'/ESSID:"(.*?)"/ && print $1')

#------------------------------------------------------------------------

echo " $QUALITY% [$ESSID]" # full text
echo " $QUALITY% [$ESSID]" # short text

# color
if [[ $QUALITY -ge 70 ]]; then
    echo "#00FF00"
elif [[ $QUALITY -ge 50 ]]; then
    echo "#FFF600"
elif [[ $QUALITY -ge 30 ]]; then
    echo "#FFAE00"
else
    echo "#FF0000"
fi

export TERM=xTerm

case "$BLOCK_BUTTON" in
    1)
       nm-connection-editor
esac

