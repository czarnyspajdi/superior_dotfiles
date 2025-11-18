#!/bin/bash

# colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

# functions
function install_yay() {
    echo "Yay is not installed, installing..."
    sudo pacman -S --needed git base-devel
    tmpdir="$(mktemp -d)"
    git clone https://aur.archlinux.org/yay.git "$tmpdir"
    cd "$tmpdir"
    makepkg -si
    cd -
    rm -rf "$tmpdir"
}
# pkgs lists
HYPR_PKGS="
hyprcursor
hyprgraphics
hypridle
hyprland
hyprland-qt-support
hyprland-qtutils
hyprlang
hyprlock
swww
waypaper
hyprpolkitagent
hyprsunset
hyprutils
hyprwayland-scanner
xdg-desktop-portal-hyprland
xdg-desktop-portal-gtk
mako
libnotify
hyprlauncher
"

SOUND_PKGS="
pipewire
wireplumber
pipewire-audio
pipewire-alsa
pipewire-pulse
pavucontrol
"
UTIL_PKGS="
fish
neovim
uwsm
python3
util-linux
libnewt
kitty
yazi
playerctl
flatpak
wl-clipboard
scx-scheds
man-db
fastfetch
btop
file
nerd-fonts
ffmpeg
7zip
jq
poppler
fd
ripgrep
fzf
zoxide
imagemagick
bat
eza
npm
bc
chezmoi
github-cli
openssh
socat
otf-font-awesome
papirus-icon-theme
hicolor-icon-theme
noto-fonts-emoji
cliphist
"

GUI_PKGS="
zen-browser-bin
vesktop
mangohud
goverlay
steam
gimp
gamescope
gamemode
bluez
bluez-utils
blueman
waybar
heroic-games-launcher
feh
slurp
grim
"

PRINT_PKGS="
cups
cups-browsed
"

THEME_PKGS="
catppuccin-gtk-theme-latte
"

PKGS=( $HYPR_PKGS $SOUND_PKGS $UTIL_PKGS $GUI_PKGS $PRINT_PKGS  )

echo "Downloading packages..."
sudo pacman -Syu --needed "${PKGS[@]}"

if ! groups "$USER" | grep -qw "gamemode"; then
    sudo usermod -aG gamemode "$USER"
fi

if ! echo $PATH | grep -q "$HOME/.local/bin"; then
    fish -c "fish_add_path \"$HOME/.local/bin\""
fi

if ! echo $SHELL | grep -qw "/usr/bin/fish"; then
    chsh -s "$(command -v fish)"
fi

if ! pacman -Q yay &>/dev/null; then
    install_yay
else
	echo "Yay is installed..."
fi

echo "Flatpak install..."

flatpak update --noninteractive
flatpak install --noninteractive com.github.tchx84.Flatseal com.spotify.Client

echo "Services setup..."

systemctl --user enable hypridle hyprpolkitagent pipewire-pulse
sudo systemctl enable bluetooth cups

echo "Downloading theme with yay..."
yay -S $THEME_PKGS --needed

echo -e "${BOLD}${GREEN}All done!${RESET}"
