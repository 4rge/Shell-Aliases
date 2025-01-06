load_setopts() {
    local setopt_file="$HOME/.setopts.yaml"  # first check for YAML
    if [ -f "$setopt_file" ]; then
        if command -v yq > /dev/null; then
            while IFS="=" read -r key value; do
                if [ "$value" = "true" ]; then
                    setopt "$key"  # enable the option
                elif [ "$value" = "false" ]; then
                    unsetopt "$key"  # disable the option
                fi
            done < <(yq -r '. | to_entries | .[] | "\(.key)=\(.value)"' "$setopt_file")
        else
            echo "yq is not installed. Please install it to load YAML setopts."
        fi
    else
        setopt_file="$HOME/.setopts.json"  # if YAML not found, check for JSON
        if [ -f "$setopt_file" ]; then
            if command -v jq > /dev/null; then
                while IFS="=" read -r key value; do
                    if [ "$value" = "true" ]; then
                        setopt "$key"  # enable the option
                    elif [ "$value" = "false" ]; then
                        unsetopt "$key"  # disable the option
                    fi
                done < <(jq -r 'to_entries | .[] | "\(.key)=\(.value)"' "$setopt_file")
            else
                echo "jq is not installed. Please install it to load JSON setopts."
            fi
        else
            echo "No setopt file found. Please create either ~/.setopts.yaml or ~/.setopts.json."
        fi
    fi
}

# Load aliases and setopts by calling the functions 
load_setopts
