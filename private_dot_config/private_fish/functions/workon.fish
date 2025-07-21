function workon --wraps='source ./bin/activate.fish' --description 'alias workon=source ./bin/activate.fish'
  source ./bin/activate.fish $argv
        
end
