load_aliases() {
    local aliases_file="$HOME/.aliases.yaml"  # first check for YAML
    if [ -f "$aliases_file" ]; then
        if command -v yq > /dev/null; then
            while IFS="=" read -r key value; do
                alias "$key"="$value"
            done < <(yq '. | to_entries | .[] | "\(.key)=\(.value)"' "$aliases_file")
        else
            echo "yq is not installed. Please install it to load YAML aliases."
        fi
    else
        aliases_file="$HOME/.aliases.json"  # if YAML not found, check for JSON
        if [ -f "$aliases_file" ]; then
            if command -v jq > /dev/null; then
                while IFS="=" read -r key value; do
                    alias "$key"="$value"
                done < <(jq -r 'to_entries | .[] | "\(.key)=\(.value)"' "$aliases_file")
            else
                echo "jq is not installed. Please install it to load JSON aliases."
            fi
        else
            echo "No aliases file found. Please create either ~/.aliases.yaml or ~/.aliases.json."
        fi
    fi
}

load_aliases  # Call the function to load aliases
