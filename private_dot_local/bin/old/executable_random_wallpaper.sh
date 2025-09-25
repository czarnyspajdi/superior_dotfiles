#!/usr/bin/env bash

case $1 in
    "nsfw")
        WALLPAPER_DIR="$HOME/Obrazy/tapety/nsfw/"
        ;;
    "sfw")
        WALLPAPER_DIR="$HOME/Obrazy/tapety/sfw/"
        ;;
    *)
        echo "Please choose nsfw or sfw"
        exit 1
esac
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
hyprctl hyprpaper reload ,"$WALLPAPER"
