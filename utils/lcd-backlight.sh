#!/bin/bash

# Francisco Diéguez Souto (frandieguez@ubuntu.com)
# This script is licensed under MIT License.
#
# This program just modifies the value of backlight keyboard for Apple Laptops
# You must run it as root user or via sudo.
# As a shortcut you could allow to admin users to run via sudo without password
# prompt. To do this you must add sudoers file the next contents:
#
#  Cmnd_Alias CMDS = /usr/local/bin/keyboard-backlight
#  %admin ALL = (ALL) NOPASSWD: CMDS
#
# After this you can use this script as follows:
#
#     Increase backlight keyboard:
#	    $ sudo keyboard-backlight up
#     Decrease backlight keyboard:
#	    $ sudo keyboard-backlight down
#     Increase to total value backlight keyboard:
#	    $ sudo keyboard-backlight total
#     Turn off backlight keyboard:
#	    $ sudo keyboard-backlight off
#
# You can customize the amount of backlight by step by changing the INCREMENT
# variable as you want it.

SYSPATH="/sys/class/backlight/intel_backlight/brightness"
BACKLIGHT=$(cat "$SYSPATH")
MAXBACKLIGHT=$(cat /sys/class/backlight/intel_backlight/max_brightness)
INCREMENT=$(($MAXBACKLIGHT/15))
#if [ $UID -ne 0 ]; then
#    echo "Please run this program as superuser"
#    exit 1
#fi

SET_VALUE=0

case $1 in

    up)
        TOTAL=`expr $BACKLIGHT + $INCREMENT`
        if [ $TOTAL -gt "$MAXBACKLIGHT" ]; then
            TOTAL=$MAXBACKLIGHT
        fi
        SET_VALUE=1
        ;;
    down)
        TOTAL=`expr $BACKLIGHT - $INCREMENT`
        if [ $TOTAL -lt "0" ]; then
            TOTAL=0
        fi
        SET_VALUE=1
        ;;
    total)
        TEMP_VALUE=$BACKLIGHT
        while [ $TEMP_VALUE -lt "$MAXBACKLIGHT" ]; do
            TEMP_VALUE=`expr $TEMP_VALUE + 1`
            if [ $TEMP_VALUE -gt "$MAXBACKLIGHT" ]; then TEMP_VALUE="$MAXBACKLIGHT"; fi
            echo $TEMP_VALUE > $SYSPATH
        done
        ;;
    off)
        TEMP_VALUE=$BACKLIGHT
        while [ $TEMP_VALUE -gt "0" ]; do
            TEMP_VALUE=`expr $TEMP_VALUE - 1`
            if [ $TEMP_VALUE -lt "0" ]; then TEMP_VALUE=0; fi
            echo $TEMP_VALUE > $SYSPATH
        done
        ;;
    *)
        echo "Use: keyboard-light up|down|total|off"
        ;;
esac

if [ $SET_VALUE -eq "1" ]; then
    echo $TOTAL > $SYSPATH
fi

RATIO=$(( $TOTAL * 100 / $MAXBACKLIGHT ))
if [[ $RATIO -gt 66 || $RATIO -eq 100 ]]
then
    ICORATIO="/usr/share/icons/gnome-colors-common/scalable/notifications/notification-display-brightness-high.svg"
else
    if [[ $RATIO -gt 33 ]]
    then
        ICORATIO="/usr/share/icons/gnome-colors-common/scalable/notifications/notification-display-brightness-medium.svg"
    else 
        if [[ $RATIO -gt 0 ]]
        then 
            ICORATIO="/usr/share/icons/gnome-colors-common/scalable/notifications/notification-display-brightness-low.svg"
        else
            a
            ICORATIO="/usr/share/icons/gnome-colors-common/scalable/notifications/notification-display-brightness-off.svg"
        fi
    fi
fi

notify-send "Luminosité" -i $ICORATIO -h int:value:$RATIO
