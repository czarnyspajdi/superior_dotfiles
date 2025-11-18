if status is-interactive
    # editors for yazi
    export EDITOR="nvim"
    export VISUAL="nvim"
    # better shell history
    atuin init fish | source
    # no dum greeting
    set fish_greeting ""
    # yes, please setup git for me
    gh auth setup-git
    # add github ssh key
    eval (ssh-agent -c)
    ssh-add ~/.ssh/github
    # vi mode
    fish_vi_key_bindings

    # better cd
    zoxide init fish | source
    clear
    fastfetch --config ~/.config/fastfetch/startup.jsonc
end

# Added by LM Studio CLI (lms)
set -gx PATH $PATH /home/szymon/.lmstudio/bin
# End of LM Studio CLI section

