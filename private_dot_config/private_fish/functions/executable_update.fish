function update --description "update system"
    if not yay
        sudo pacman -Syu
    end

    set orphans (pacman -Qtdq)
    if test (count $orphans) -gt 0
        sudo pacman -Rns $orphans
    end

    flatpak update --noninteractive $argv
end
