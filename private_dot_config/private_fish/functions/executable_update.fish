function update --description "update system"
    echo "===System update==="
    if not yay
        sudo pacman -Syu
    end

    echo "===Remove orphans==="
    set orphans (pacman -Qtdq)
    if test (count $orphans) -gt 0
        sudo pacman -Rns $orphans
    end

    echo "===Flatpak update==="
    flatpak update --noninteractive
    echo "===Flatpak remove unused==="
    flatpak uninstall --unused
end
