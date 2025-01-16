function project() {
    # Check if the filename is provided as an argument
    [ -z "$1" ] && echo "Usage: create_project <filename>" && return 1

    FILENAME=$1
    # Extract file extension
    EXT="${FILENAME##*.}"
    # Create the project directory name without the extension
    DIR_NAME="${FILENAME%.*}"

    # Set the target directory to ~/DIR_NAME/files
    TARGET_DIR="$HOME/$DIR_NAME"
    
    # Create the target directory
    mkdir -p "$TARGET_DIR" || { echo "Failed to create directory"; return 1; }
    cd "$TARGET_DIR" || { echo "Failed to enter directory"; return 1; }

    # Initialize git
    git init

    # Create a template README file
    echo "# $DIR_NAME" > README.md

    # Define a hash table for the templates
    typeset -A templates
    templates[sh]="#!/bin/bash"
    templates[python]="__main__.py|if __name__ == '__main__':\n    main()\n\n__init__.py\ndef main():\n    pass"
    templates[html]="index.html|<!DOCTYPE html>\n<html>\n  <head>\n    <title>$DIR_NAME</title>\n  </head>\n  <body>\n    <h1>Welcome to $DIR_NAME</h1>\n  </body>\n</html>"

    # Determine the template based on the file extension
    {
        [ -n "${templates[$EXT]}" ] && {
            IFS='|' read -r main_file content <<< "${templates[$EXT]}"
            echo -e "$content" > "$main_file"

            # Apply chmod based on the extension
            case "$EXT" in
                sh) chmod +x "$main_file" ;;  # Make the Bash script executable
                python) chmod +x "$TARGET_DIR" ;;  # Permissions for the directory (generally unnecessary)
                html) ;;  # Do nothing for HTML
            esac

            cd "$TARGET_DIR" || return 1
            vim "$main_file"
        } || {
            echo "Unknown file extension: $EXT. Supported extensions are: .sh, .py, .html."
            return 1
        }
    }

    echo "Project $DIR_NAME created successfully at $TARGET_DIR!"
    cd - || return 1  # Return to the previous directory
}
