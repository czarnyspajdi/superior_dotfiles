#!/bin/bash

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

# functions
function install_yay() {
    echo "Checking if yay is installed..."
    if ! command -v yay &> /dev/null; then
        echo "Yay is not installed, installing..."
        sudo pacman -S --needed git base-devel
        tmpdir="$(mktemp -d)"
        git clone https://aur.archlinux.org/yay.git "$tmpdir"
        cd "$tmpdir"
        makepkg -si || { echo "Yay installation failed!"; exit 1; }
        cd -
        rm -rf "$tmpdir"
    fi
    echo "Yay is installed!"
}

function show_help() {
    echo -e "$help_message"
    exit 0
}

function list_presets() {
    echo -e "Existing presets:\n\tmiminal - a minimal preset with not a lot of stuff\n\tnormal - preset with everything you could possibly need"
    exit 0
}

function list_preset_packages() {
    echo "Preset $preset contains:"
    echo "${presets[$preset]}"
    exit 0
}

function install_preset() {
    install_yay
    echo "Downloading preset: $preset"
    yay -Syu ${presets[$preset]} --needed
}

function uninstall_preset() {
    reassurance=""
    read -p "Are you sure you want to do this very stupid thing? Type I AM VERY DUM to continue..." reassurance
    if [[ $reassurance = "I AM VERY DUM" ]]; then
        echo "Uninstalling preset: $preset"
        yay -Rns ${presets[$preset]}
    else
        echo "Canceled uninstall"
    fi
    exit 0
}

function enable_services() {
    sudo systemctl enable sddm bluetooth NetworkManager cups
    systemctl --user enable pipewire wireplumber
}

# pkgs lists
HYPRLAND_UI="
hyprland
hyprland-protocols
hyprlauncher
hypridle
hyprlock
hyprpaper
hyprpolkitagent
hyprpwcenter
hyprsunset
hyprwire
waybar
grim
slurp
swww
wl-clipboard
nwg-displays
nwg-look
waypaper
xdg-desktop-portal-gtk
xdg-desktop-portal-hyprland
mako
notification-daemon
libnotify
sddm
"

THEME="
adw-gtk-theme
catppuccin-gtk-theme-latte
papirus-icon-theme
rose-pine-cursor
rose-pine-hyprcursor
"

AUDIO="
pipewire
pipewire-alsa
pipewire-pulse
wireplumber
pavucontrol
cava
"

NETWORK="
networkmanager
network-manager-applet
blueman
bluez
bluez-utils
bluez-cups
openssh
sshfs
aria2
wget
rclone
"

PRINTERS="
cups
cups-browsed
cups-pdf
system-config-printer
sane
sane-airscan
"

FILESYSTEM="
btrfs-progs
btrfs-assistant
snapper
ntfs-3g
dosfstools
zip
7zip
rsync
trash-cli
"

TERMINAL_TOOLS="
fish
yazi
playerctl
atuin
zoxide
eza
fd
ripgrep
fzf
duf
gdu
fastfetch
tealdeer
man-db
bc
mediainfo
"

DEV="
cmake
go
rust
rust-analyzer
python-pip
prettier
npm
pandoc-cli
tectonic
chezmoi
neovim
lazygit
github-cli
"

GAMES="
steam
heroic-games-launcher-bin
lutris
wine
winetricks
protontricks
prismlauncher
gamemode
gamescope
mangohud
lact
goverlay
"

MULTIMEDIA="
mpv
satty
gimp
kdenlive
imagemagick
feh
"

DOCUMENTS="
zathura
zathura-pdf-poppler
"

USERSPACE="
gurk
vesktop
openrgb
homebank
winboat
freetube
zen-browser-bin
"

declare -A presets
presets[minimal]="$HYPRLAND_UI $AUDIO $TERMINAL_TOOLS"
presets[normal]="$HYPRLAND_UI $AUDIO $TERMINAL_TOOLS $THEME $NETWORK $FILESYSTEM $USERSPACE $DOCUMENTS $MULTIMEDIA $PRINTERS $DEV $GAMES"

wants_help=false
list=false
list_presets=false
install=false
uninstall=false
services=false
preset=""

help_message="Super cool system setup utility that downloads all the packages you could possibly need!\n
How to use this bad boy:\n\n
\t--help - show this help message and leave\n
\t--list - list what is in given preset and leave. You can only use this option with --preset!\n
\t--preset - choose a preset you want to use\n
\t--services - enable all services after installing packages\n
\t--install - installs given preset to your system\n
\t--uninstall - uninstall given preset from your system. Possibly very stupid, because presets contain important system packages, like your window manager!\n\n
Thanks for using my super cool script :D
"

# check root
if [ "$EUID" -eq 0 ]; then
    echo -e "${RED}Please do not run this script as root.${RESET}"
    exit 1
fi

# check args
if [[ -z "$1" ]]; then
    echo "You need to give me some arguments...\nTry --help if you don't know what you're doing"
    exit 1
fi

# parse args
while [ -n "$1" ]; do
    case $1 in
        --list-presets)
            list_presets=true
            shift
            ;;
        --list)
            list=true
            shift
            ;;
        --preset)
            if [ -n "$2" ]; then
                preset="$2"
                shift 2
            else
                echo "Error: --preset requires one argument"
                exit 1
            fi
            ;;
        --help)
            wants_help=true
            shift 1
            ;;
        --install)
            install=true
            shift
            ;;
        --uninstall)
            uninstall=true
            shift
            ;;
        --services)
            services=true
            shift
            ;;
        *)
            echo "$1 is not a valid option! What are you even doing?!"
            shift
            ;;
    esac
done   

if [[ "$wants_help" = true ]]; then
    show_help
fi

if [[ "$list_presets" = true ]]; then
    list_presets
fi

if [[ -v presets[$preset] ]]; then
    if [[ "$list" = true ]]; then
        list_preset_packages
    fi
    if [[ "$install" = true ]]; then
        install_preset
        if [[ "$services" = true ]]; then
            enable_services
        fi
    fi
    if [[ "$uninstall" = true ]]; then
        uninstall_preset
    fi
else
    echo "Given preset does not exists..."
fi
