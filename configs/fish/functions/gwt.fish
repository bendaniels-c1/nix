function gwt
    set branch $argv[1]
    set path "../c1-"(string replace -a '/' '-' $branch)
    git worktree add -b $branch $path origin/$branch --track
end