# Define command-to-alias mapping
declare -A cmd_aliases=(
    [docker]=d
    [git]=g
    [systemctl]=sc
    [tmux]=t
    [xargs]=x
    [zellij]=zj
)

for cmd in "${(@k)cmd_aliases}"; do
    alias_name=${cmd_aliases[$cmd]}

    # Check if the command exists
    if command -v $cmd &>/dev/null; then
        # Check if completion function exists
        if whence "_$cmd" &>/dev/null; then
            compdef "$alias_name"=$cmd
        else
            #echo "Warning: No completion function for $cmd"
        fi
    fi
done

