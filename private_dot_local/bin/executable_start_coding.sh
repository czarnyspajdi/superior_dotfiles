#!/bin/bash

dir=$(find ~/Dokumenty/kodowanie/ -maxdepth 2 -type d ! -name '.*' | fzf)
export EDITOR="nvim"

if [[ -n $dir ]]; then
    echo "You choose $dir"
    hyprctl dispatch exec [workspace 5] kitty $dir
    hyprctl dispatch exec [workspace 5] kitty yazi $dir
    hyprctl dispatch exec [workspace 5] kitty $dir
else
    echo "No reasonable directory selected, bye bye :P"
fi
