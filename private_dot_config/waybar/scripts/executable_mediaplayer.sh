#!/bin/sh

set -x

if [ -z "$1" ]; then
  echo "Użycie: $0 <nazwa_odtwarzacza>"
  exit 1
fi

player="$1"
playerctl -p "$player" metadata --format "{{status}} {{artist}} - {{title}}" --follow | while read -r line; do
  current_status=$(playerctl --player="$player" status 2>/dev/null)
  case "$current_status" in
  "Playing")
    text=""
    ;;
  "Paused")
    text=""
    ;;
  *)
    text=""
    ;;
  esac
  tooltip=$(playerctl --player="$player" metadata --format "{{artist}} - {{title}}" 2>/dev/null)

  tooltip=$(echo "$tooltip" | jq -R .)

  json_text="{\"text\": \"$text\", \"tooltip\": $tooltip }"
  echo "$json_text"

  if [[ -n "$text" ]]; then
    pkill -SIGRTMIN+1 waybar
  fi
done
