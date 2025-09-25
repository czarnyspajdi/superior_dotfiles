#!/bin/bash

declare -A blue
blue[background]="rgba(36, 158, 202, 0.20)"
blue[foreground]="rgba(36, 158, 202, 0.30)"
blue[font-color]="#499DA9"
blue[wallpaper]="~/Obrazy/tapety/niebieski.jpg"

declare -A red
red[background]="rgba(202, 36, 36, 0.20)"
red[foreground]="rgba(202, 36, 36, 0.30)"
red[font-color]="#A94949"
red[wallpaper]="~/Obrazy/tapety/czerwony.jpg"

declare -A gray
gray[background]="rgba(169, 169, 169, 0.20)"
gray[foreground]="rgba(169, 169, 169, 0.30)"
gray[font-color]="#A9A9A9"
gray[wallpaper]="~/Obrazy/tapety/szary.jpg"

choosen_color=$1
if [[ -z $choosen_color ]]; then
    choosen_color=$(echo -e "blue\nred\ngray\n" | wofi --show dmenu --prompt "Choose your theme")
fi

echo "You choose: $(choosen_color)"

if [[ $choosen_color == "blue" ]]; then
    waybar_colors="@define-color background ${blue[background]};\n@define-color foreground ${blue[foreground]};\n@define-color font-color ${blue[font-color]};"
    mako_colors="blue"
    wofi_colors="#249ECA\n#499DA9"
    rivalcfg --strip-top-color "#249ECA" --strip-middle-color "#249ECA" --strip-bottom-color "#249ECA" -c "#249ECA"
    hyprctl hyprpaper reload ,${blue[wallpaper]}
    echo -e "preload = ${blue[wallpaper]}\nwallpaper = ,${blue[wallpaper]}\nsplash = off\nipc = on" > ~/.config/hypr/hyprpaper.conf
elif [[ $choosen_color == "red" ]]; then
    waybar_colors="@define-color background ${red[background]};\n@define-color foreground ${red[foreground]};\n@define-color font-color ${red[font-color]};"
    mako_colors="red"
    wofi_colors="#CA2424\n#A94949"
    rivalcfg --strip-top-color "#CA2424" --strip-middle-color "#CA2424" --strip-bottom-color "#CA2424" -c "#CA2424"
    hyprctl hyprpaper reload ,${red[wallpaper]}
    echo -e "preload = ${red[wallpaper]}\nwallpaper = ,${red[wallpaper]}\nsplash = off\nipc = on" > ~/.config/hypr/hyprpaper.conf
elif [[ $choosen_color == "gray" ]]; then
    waybar_colors="@define-color background ${gray[background]};\n@define-color foreground ${gray[foreground]};\n@define-color font-color ${gray[font-color]};"
    mako_colors="gray"
    wofi_colors="#A9A9A9\n#A9A9A9"
    rivalcfg --strip-top-color "#A9A9A9" --strip-middle-color "#A9A9A9" --strip-bottom-color "#A9A9A9" -c "#A9A9A9"
    hyprctl hyprpaper reload ,${gray[wallpaper]}
    echo -e "preload = ${gray[wallpaper]}\nwallpaper = ,${gray[wallpaper]}\nsplash = off\nipc = on" > ~/.config/hypr/hyprpaper.conf
fi


echo -e "$waybar_colors" > ~/.config/waybar/colors.css
~/.local/bin/restart_waybar.sh &

# killall mako
cat ~/.config/mako/$mako_colors > ~/.config/mako/config
makoctl reload
# mako --config ~/.config/mako/$mako_colors &

echo -e $wofi_colors > ~/.config/wofi/colors

