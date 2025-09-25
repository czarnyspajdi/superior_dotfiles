#!/bin/bash

### DEPENDENCIES:
## libnotify
## feh
## grim
## slurp
## satty
## wl-clipboard

dir_target="$HOME/Obrazy/zrzuty" # where your screenshots are stored
file_name="zrzut_$(date +'%H-%M-%S_%d-%m-%Y').png" # name of your screenshot
file_path="$dir_target/$file_name" # full path combined of the above
tmp_path="/tmp/$file_name" # path of temporary file

# flags
edit=false # edit after screenshotting
save=false # save to the disk
copy=false # copy to clipboard

# messages

error_message="No argument provided. Use -h or --help for help message."
help_message="\nUsage: screenShot [flags] [type-of-screen-shot / color (for color picker)\n\nFlags:\n\t-c | --copy \t Copies to clipboard\n\t-s | --save \t Saves to $dir_target\n\t-e | --edit \t Edit screenshot with swappy\n\nTypes:\n\tfullscreen\n\twindow\n\tregion\n"

# don't go crazy when directory doesn't exist

if [[ ! -d $dir_target ]]; then
    echo "Target directory does not exist. Creating..."
    notify-send "Screenshot" "Target directory does not exist. Creating..."
    mkdir -p $dir_target
fi

# handle flags
while [[ $# -gt 0 ]]; do
  case "$1" in
  -c | --copy)
    copy=true
    ;;
  -s | --save)
    save=true
    ;;
  -e | --edit)
    edit=true
    ;;
  -h | --help)
    echo -e "$help_message"
    exit 0
    ;;
  fullscreen | window | region | color)
    type_of_screenshot="$1"
    ;;
  *)
    echo "$error_message"
    exit 1
    ;;
  esac
  shift
done

# actually screenshot
case "$type_of_screenshot" in
fullscreen)
  grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') "$tmp_path"
  ;;
window)
  active_window_position="$(hyprctl clients -j | jq -r '.[] | select(.focusHistoryID == 0) | .at')"
  active_window_size="$(hyprctl clients -j | jq -r '.[] | select(.focusHistoryID == 0) | .size')"

  x=$(echo "$active_window_position" | jq '.[0]')
  y=$(echo "$active_window_position" | jq '.[1]')
  width=$(echo "$active_window_size" | jq '.[0]')
  height=$(echo "$active_window_size" | jq '.[1]')

  grim -g "${x},${y} ${width}x${height}" "$tmp_path"
  ;;
region)
  grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') "$tmp_path" && feh --title screenshot --fullscreen "$tmp_path" &
  sleep 0.5
  feh_pid=$(pgrep feh)
  grim -g "$(slurp)" "$tmp_path"
  echo "Killing feh…"
  kill -9 "$feh_pid"
  ;;
color)
  grim -o $(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name') "$tmp_path" && feh --title screenshot --fullscreen "$tmp_path" &
  sleep 0.5
  feh_pid=$(pgrep feh)
  position=$(slurp -p)
  sleep 1.0
  color_hex=$(grim -g "$position" -t ppm - | magick convert - -format '%[pixel:p{0,0}]' txt:- | sed -n '2p' | awk '{print $3}')
  wl-copy $color_hex
  notify-send "Color picker" "Copied $color_hex to clipboard"
  kill -9 "$feh_pid"
  exit 0
  ;;

esac

case "$copy-$save" in
"true-true")
  cp "$tmp_path" "$file_path"
  wl-copy <"$tmp_path"
  notify-send -i "$tmp_path" "Screenshot" "Copied and saved to $file_path"
  ;;
"false-true")
  cp "$tmp_path" "$file_path"
  notify-send -i "$tmp_path" "Screenshot" "Saved screenshot to $file_path"
  ;;
"true-false")
  wl-copy <"$tmp_path"
  notify-send -i "$tmp_path" "Screenshot" "Copied screenshot"
  ;;
"false-false")
  if [ "$edit" = "true" ]; then
    satty -f "$tmp_path"
  fi
  ;;
esac

rm $tmp_path

exit 0
