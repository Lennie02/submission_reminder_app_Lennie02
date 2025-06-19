#!/bin/bash

# Get the absolute path of the current script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Search for project directories ---
project_dirs=()
while IFS= read -r dir; do
    project_dirs+=("$dir")
done < <(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d -name "submission_reminder_*")

# --- No projects found ---
if [ ${#project_dirs[@]} -eq 0 ]; then
    printf "\n\e[31mNo project directory found.\nPlease run the environment setup script first.\e[0m\n\n"
    exit 1
fi

# --- Handle single or multiple projects ---
if [ ${#project_dirs[@]} -eq 1 ]; then
    PROJECT_DIR="${project_dirs[0]}"
    dir_name=$(basename "$PROJECT_DIR")
    echo -e "\nOne project directory found: \e[32m$dir_name\e[0m\n"
else
    echo -e "\n\e[33mMultiple project directories found:\e[0m"
    for i in "${!project_dirs[@]}"; do
        dir_name=$(basename "${project_dirs[$i]}")
        echo "  [$i] $dir_name"
    done
    echo
    read -p "Enter the number of the project you want to use: " choice

    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -ge "${#project_dirs[@]}" ]; then
        printf "\n\e[31mInvalid selection.\e[0m\n"
        read -p "Do you want to restart the Submission Reminder App? (yes/no): " retry_choice
        if [[ "$retry_choice" =~ ^(yes|y)$ ]]; then
            exec "$0"
        else
            printf "\n\e[33mExiting Helen's Submission Reminder App. Goodbye!\e[0m\n\n"
            exit 1
        fi
    fi

    PROJECT_DIR="${project_dirs[$choice]}"
fi

# --- Set root directory for use in sourced scripts ---
export root_dir="$PROJECT_DIR"
cd "$PROJECT_DIR" || exit

# --- Load function definitions ---
if [[ ! -f "modules/functions.sh" ]]; then
    printf "\e[31m\nMissing modules/functions.sh file. Exiting.\n\e[0m\n"
    exit 1
fi
source "modules/functions.sh"

# --- Check and load config ---
if [[ ! -f "config/config.env" ]]; then
    printf "\e[31m\nMissing config/config.env. Please run the setup script.\n\e[0m\n"
    option_menu_after_setup
    exit 1
fi
source config/config.env

# --- Prompt user for assignment name ---
while true; do
    read -p "Enter the assignment name: " assignment_name
    if [[ -z "$assignment_name" ]]; then
        printf "\e[31mAssignment name cannot be empty.\e[0m\n"
        read -p "Do you want to try again? (yes/no): " retry
        if [[ "$retry" =~ ^(yes|y)$ ]]; then
            continue
        else
            printf "\n\e[33mExiting Helen's Submission Reminder App. Goodbye!\e[0m\n\n"
            exit 1
        fi
    else
        break
    fi
done

# --- Update the config.env file ---
if [[ "$(uname)" == "Darwin" ]]; then
    sed -i '' "2s/.*/ASSIGNMENT=\"$assignment_name\"/" "config/config.env"
else
    sed -i "2s/.*/ASSIGNMENT=\"$assignment_name\"/" "config/config.env"
fi

# Reload the updated config
source config/config.env

# Confirm to user
printf "\nAssignment updated to '\e[32m%s\e[0m' in config.env\n\n" "$ASSIGNMENT"
sleep 1


