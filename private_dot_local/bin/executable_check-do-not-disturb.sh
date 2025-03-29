#!/bin/bash

disturbed=$(makoctl mode | grep -i do-not-disturb) > /dev/null
mute_icon=""
unmute_icon="🕭"

case $1 in
    "show")
        if [[ $disturbed == "" ]]; then
            echo "$unmute_icon"
        else
            echo "$mute_icon"
        fi
    ;;
    "change")
        if [[ $disturbed == "" ]]; then
            makoctl mode -a do-not-disturb > /dev/null
            echo "$unmute_icon"
        else
            makoctl mode -r do-not-disturb > /dev/null
            echo "$mute_icon"
        fi
        pkill -SIGRTMIN+2 waybar
    ;;
    *)
    echo "Arguments are: show, change"
    ;;
esac
