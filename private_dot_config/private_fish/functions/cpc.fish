function cpc
    if test (count $argv) -eq 1
        set filename (basename $argv[1] .cpp)
        g++ -o $filename $argv[1]
        if test -x $filename
            ./$filename
            rm $filename
        else
            echo "Compilation failed."
        end
    else
        echo "Usage: cpc filename.cpp"
    end
end
