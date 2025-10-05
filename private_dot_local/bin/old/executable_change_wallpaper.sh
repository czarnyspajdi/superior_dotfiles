#!/bin/bash

case $1 in
    "sfw")
        wallpaper=$(find ~/Obrazy/tapety/sfw/ -type f | wofi --dmenu)
        ;;
    "nsfw")
        wallpaper=$(find ~/Obrazy/tapety/nsfw/ -type f | wofi --dmenu)
        ;;
    *)
        echo "Please choose nsfw or sfw"
        exit 1
        ;;
esac

if [[ -n $wallpaper ]];then
    hyprctl hyprpaper reload ,$wallpaper
fi
