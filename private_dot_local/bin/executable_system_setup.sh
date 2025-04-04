#!/bin/bash
set -e
echo "Packags..."
sudo pacman -Syu fish neovim uwsm python3 util-linux libnewt wofi kitty yazi playerctl tldr flatpak zen-browser-bin wl-clipboard hyprland hyprpaper hypridle hyprlock xdg-desktop-portal-hyprland xdg-desktop-portal-gtk scx-scheds pipewire wireplumber pavucontrol man-db fastfetch btop pipewire-audio pipewire-alsa pipewire-pulse mako libnotify feh slurp grim swappy cliphist file nerd-fonts ffmpeg 7zip jq poppler fd ripgrep fzf zoxide imagemagick bat eza npm bc vesktop mangohud goverlay steam gimp spotify-launcher obs-studio gamescope gamemode bluez bluez-utils blueman heroic-games-launcher chezmoi github-cli openssh socat otf-font-awesome greetd-regreet papirus-icon-theme hicolor-icon-theme noto-fonts-emoji batsignal waybar --needed --noconfirm

if ! groups "$USER" | grep -qw "gamemode"; then
    sudo usermod -aG gamemode "$USER"
fi

if ! echo $PATH | grep -q "$HOME/.local/bin"; then
    fish_add_path "$HOME/.local/bin"
fi

if ! echo $SHELL | grep -qw "/usr/bin/fish"; then
    chsh -s "$(command -v fish)"
fi

if ! pacman -Q yay &>/dev/null; then
	echo "Yay is not installed, installing..."
	sudo pacman -S --needed git base-devel
	git clone https://aur.archlinux.org/yay.git $HOME/yay
	cd $HOME/yay
	makepkg -si
	cd ..
	rm yay -rf
else
	echo "Yay is installed..."
	yay -S hyprsunset hyprpolkitagent --needed
fi

echo "flatpak..."

flatpak update --noninteractive
flatpak install --noninteractive net.rpcs3.RPCS3

echo "Services..."

systemctl --user enable hypridle hyprpolkitagent pipewire-pulse hypridle waybar hyprpaper
sudo systemctl enable bluetooth greetd

echo "All done"
