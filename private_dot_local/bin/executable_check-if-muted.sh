#!/bin/bash

MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -iq muted; echo $?)

if [[ $MUTED -eq 0 ]]; then
    notify-send "Audio muted" -a 'wp-vol' -t 1000
else
    notify-send "Audio unmuted" -a 'wp-vol' -t 1000
fi
