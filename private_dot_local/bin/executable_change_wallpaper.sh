#!/bin/bash

wallpaper=$(find ~/Obrazy/tapety/ -type f | wofi --dmenu)

if [[ -n $wallpaper ]];then
    hyprctl hyprpaper reload ,$wallpaper
fi
