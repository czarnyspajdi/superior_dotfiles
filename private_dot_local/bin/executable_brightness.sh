#!/usr/bin/bash

if [[ $1 == "up" ]]; then
    ddcutil -d 1 setvcp 10 100 && ddcutil -d 2 setvcp 10 100
elif [[ $1 == "down" ]]; then
    ddcutil -d 1 setvcp 10 30 && ddcutil -d 2 setvcp 10 0
else
    echo "Usage: brightness.sh [up/down]"
fi
