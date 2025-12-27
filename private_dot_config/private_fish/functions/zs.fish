function zs --description 'zoxide jump with fzf'
    set -l dir (zoxide query -i)
    test -n "$dir"; and z "$dir"
end
