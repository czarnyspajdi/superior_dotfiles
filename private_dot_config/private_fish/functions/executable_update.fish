function update --description 'alias update=sudo pacman -Syu && flatpak update'
    yay || sudo pacman -Syu && sudo pacman -Rns (pacman -Qtdq) ; flatpak update --noninteractive $argv

end
