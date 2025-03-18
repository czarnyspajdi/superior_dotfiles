function chezedit --wraps='chezmoi edit --apply' --description 'alias chezedit=chezmoi edit --apply'
  chezmoi edit --apply $argv
        
end
