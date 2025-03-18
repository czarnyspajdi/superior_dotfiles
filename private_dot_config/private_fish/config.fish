if status is-interactive
    # editors for yazi
    export EDITOR="nvim"
    export VISUAL="nvim"
    # no dum greeting
    set fish_greeting ""
    # yes, please setup git for me
    gh auth setup-git
    # add github ssh key
    eval (ssh-agent -c)
    ssh-add ~/.ssh/github
    # better cd
    zoxide init fish | source
    clear
    fastfetch --config ~/.config/fastfetch/startup.jsonc
end
