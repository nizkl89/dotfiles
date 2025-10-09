
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Editor source
export EDITOR="nvim"

# zsh autosuggestion tool
source $HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# tmuxifier config
export PATH="$HOME/.tmuxifier/bin:$PATH"
eval "$(tmuxifier init -)"

tmuxifier() {
    if [[ "$1" == "-d" ]]; then
        local layouts_dir="$HOME/.tmuxifier/layouts"
        
        # Check if layouts directory exists
        if [[ ! -d "$layouts_dir" ]]; then
            echo "Error: Layouts directory $layouts_dir does not exist."
            return 1
        fi
        
        # Get layout files
        local layout_files=("$layouts_dir"/*.session.sh(N))
        
        # Check if any files were found
        if [[ ${#layout_files[@]} -eq 0 ]]; then
            echo "No layout files found in $layouts_dir."
            return 1
        fi

        echo "Available tmuxifier layout files:"
        local count=1
        for file in "${layout_files[@]}"; do
            echo "$count. $(basename "$file")"
            count=$((count + 1))
        done

        # Collect selected files
        local selected_files=()
        local more_files=true
        
        while [[ "$more_files" == true ]]; do
            echo ""
            echo -n "Enter the file number to be deleted (or 'n' to stop adding, 'a' to delete all): "
            read -r input
            
            input=$(echo "$input" | tr -d '[:space:]')
            
            if [[ "$input" == "n" || "$input" == "no" ]]; then
                more_files=false
            elif [[ "$input" == "a" || "$input" == "A" ]]; then
                # Add all files to selected_files
                selected_files=("${layout_files[@]}")
                echo "Added all files for deletion."
                more_files=false
            elif [[ "$input" =~ ^[0-9]+$ ]]; then
                local num=$input
                local total_files=${#layout_files[@]}
                
                if [[ "$num" -ge 1 && "$num" -le "$total_files" ]]; then
                    # Manual array indexing that works in both bash and zsh
                    local selected_file=""
                    local i=1
                    for file in "${layout_files[@]}"; do
                        if [[ $i -eq $num ]]; then
                            selected_file="$file"
                            break
                        fi
                        i=$((i + 1))
                    done
                    
                    if [[ -z "$selected_file" ]]; then
                        echo "Error: Could not find file number $num"
                        continue
                    fi
                    
                    local file_name=$(basename "$selected_file")
                    
                    # Check if already selected
                    local already_selected=false
                    for existing_file in "${selected_files[@]}"; do
                        if [[ "$existing_file" == "$selected_file" ]]; then
                            already_selected=true
                            break
                        fi
                    done
                    
                    if [[ "$already_selected" == true ]]; then
                        echo "File '$file_name' is already selected."
                    else
                        selected_files+=("$selected_file")
                        echo "Added: $file_name"
                    fi
                else
                    echo "Invalid number. Please enter a number between 1 and $total_files."
                fi
            else
                echo "Please enter a valid number, 'a' to delete all, or 'n' to stop."
            fi
        done

        # Check if any files were selected
        if [[ ${#selected_files[@]} -eq 0 ]]; then
            echo "No files selected for deletion."
            return 0
        fi

        # Show confirmation
        echo ""
        echo "You selected to delete the following files:"
        for file in "${selected_files[@]}"; do
            echo "- $(basename "$file")"
        done
        
        echo -n "Are you sure you want to delete these files? (y/n): "
        read -r confirm
        
        if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
            for file in "${selected_files[@]}"; do
                if [[ -f "$file" ]]; then
                    rm -f "$file"
                    echo "Deleted: $(basename "$file")"
                else
                    echo "Error: File not found: $file"
                fi
            done
            echo "Deletion completed."
        else
            echo "Deletion cancelled."
        fi
    else
        # Pass through to original tmuxifier command
        command tmuxifier "$@"
    fi
}

# Function to show Git branch
parse_git_branch() {
  git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

# Prompt with STarship
eval "$(starship init zsh)"
export STARSHIP_CONFIG=~/.config/starship/starship.toml
