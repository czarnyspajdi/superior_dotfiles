#!/bin/env bash

# variables
## path vars
date="$(date +'%d-%m-%Y_%H:%M:%S')"
fname="$date.png"
target_path="$HOME/Obrazy/zrzuty/$fname"
## stdout
error_wrong_type="The first argument needs to be \"fullscreen\", \"window\" or \"region\". Exiting..."
notification_succes="$target_path saved and copied"


# validate input
case "$1" in
    "fullscreen" | "window" | "region")
        type=$1
        ;;
    *)
        echo "$error_wrong_type"
        exit
        ;;
esac

notification() {
    notify-send -i "$target_path" -u low -a "Screenshot" "Screenshot $type" "$notification_succes"
}

case $type in
    "fullscreen")
        grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') "$target_path"
        wl-copy < "$target_path"
        notification
        ;;
    "window")
       active_window_position="$(hyprctl clients -j | jq -r '.[] | select(.focusHistoryID == 0) | .at')"
       active_window_size="$(hyprctl clients -j | jq -r '.[] | select(.focusHistoryID == 0) | .size')"

       x=$(echo "$active_window_position" | jq '.[0]')
       y=$(echo "$active_window_position" | jq '.[1]')
       width=$(echo "$active_window_size" | jq '.[0]')
       height=$(echo "$active_window_size" | jq '.[1]')

       grim -g "${x},${y} ${width}x${height}" "$target_path"
       wl-copy < "$target_path"
       notification
       ;;
    "region")
        grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') - | satty -f -
        ;;
esac
