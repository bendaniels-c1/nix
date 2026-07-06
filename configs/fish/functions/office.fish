function office
    if test (basename $PWD) != "c1"
        echo "Error: office must be run from in the C1 directory"
            return 1
    end
end