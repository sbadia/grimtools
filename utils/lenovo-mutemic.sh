#!/bin/bash
INPUT_DEVICE="'Capture'"

if $(amixer sget $INPUT_DEVICE,0 | grep '\[on\]' > /dev/null) ; then
    amixer sset $INPUT_DEVICE,0 toggle -q
    notify-send -u normal 'microphone muted' "Mic MUTED"
    #echo "0 blink" > /proc/acpi/ibm/led

else
    amixer sset $INPUT_DEVICE,0 toggle -q
    notify-send -u normal 'microphone unmuted' "Mic ON"
    #echo "0 on" > /proc/acpi/ibm/led
fi
