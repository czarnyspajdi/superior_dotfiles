#!/bin/bash

declare -A blue
blue[background]="rgba(36, 158, 202, 0.20)"
blue[foreground]="rgba(36, 158, 202, 0.30)"
blue[font-color]="#499DA9"

declare -A red
red[background]="rgba(202, 36, 36, 0.20)"
red[foreground]="rgba(202, 36, 36, 0.30)"
red[font-color]="#A94949"

declare -A gray
gray[background]="rgba(169, 169, 169, 0.20)"
gray[foreground]="rgba(169, 169, 169, 0.30)"
gray[font-color]="#A9A9A9"


if [[ $1 == "blue" ]]; then
    waybar_colors="@define-color background ${blue[background]};\n@define-color foreground ${blue[foreground]};\n@define-color font-color ${blue[font-color]};"
    mako_colors="blue"
    wofi_colors="#249ECA\n#499DA9"
elif [[ $1 == "red" ]]; then
    waybar_colors="@define-color background ${red[background]};\n@define-color foreground ${red[foreground]};\n@define-color font-color ${red[font-color]};"
    mako_colors="red"
    wofi_colors="#CA2424\n#A94949"
elif [[ $1 == "gray" ]]; then
    waybar_colors="@define-color background ${gray[background]};\n@define-color foreground ${gray[foreground]};\n@define-color font-color ${gray[font-color]};"
    mako_colors="gray"
    wofi_colors="#A9A9A9\n#A9A9A9"
else
    echo "Invalid color choice. Please use 'blue', 'red', or 'gray'."
    exit 1
fi


echo -e "$waybar_colors" > ~/.config/waybar/colors.css
~/.local/bin/restart_waybar.sh &

killall mako
mako --config ~/.config/mako/$mako_colors &

echo -e $wofi_colors > ~/.config/wofi/colors
