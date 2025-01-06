load_shopts() {
    local shopt_file="$HOME/.shopts.yaml"  # first check for YAML
    if [ -f "$shopt_file" ]; then
        if command -v yq > /dev/null; then
            while IFS="=" read -r key value; do
                if [ "$value" = "true" ]; then
                    shopt -s "$key"  # enable the option
                elif [ "$value" = "false" ]; then
                    shopt -u "$key"  # disable the option
                fi
            done < <(yq -r '. | to_entries | .[] | "\(.key)=\(.value)"' "$shopt_file")
        else
            echo "yq is not installed. Please install it to load YAML shopts."
        fi
    else
        shopt_file="$HOME/.shopts.json"  # if YAML not found, check for JSON
        if [ -f "$shopt_file" ]; then
            if command -v jq > /dev/null; then
                while IFS="=" read -r key value; do
                    if [ "$value" = "true" ]; then
                        shopt -s "$key"  # enable the option
                    elif [ "$value" = "false" ]; then
                        shopt -u "$key"  # disable the option
                    fi
                done < <(jq -r 'to_entries | .[] | "\(.key)=\(.value)"' "$shopt_file")
            else
                echo "jq is not installed. Please install it to load JSON shopts."
            fi
        else
            echo "No shopt file found. Please create either ~/.shopts.yaml or ~/.shopts.json."
        fi
    fi
}

# Load shopts by calling the functions
load_shopts   
