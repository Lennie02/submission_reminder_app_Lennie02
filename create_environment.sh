#!/bin/bash

read -p "Please enter your name: " user_name

# Basic validation for the name
if [[ -z "$user_name" ]]; then
  echo "Name cannot be empty. Exiting."
  exit 1
fi

# --- Create main application directory ---
DIR_NAME="./submission_reminder_${user_name}"
mkdir -p "$DIR_NAME" || { echo "Error: Failed to create directory $DIR_NAME"; exit 1; }
echo "Created main directory: $DIR_NAME"

# --- Create subdirectories ---
mkdir -p "$DIR_NAME/app"
mkdir -p "$DIR_NAME/modules"
mkdir -p "$DIR_NAME/config"
mkdir -p "$DIR_NAME/assets"
echo "Subdirectories (app, modules, config, assets) created."

# --- Create and populate config.env ---
cat > "$DIR_NAME/config/config.env" << EOF
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF
echo "Created config/config.env"

# --- Create and populate functions.sh ---
cat > "$DIR_NAME/modules/functions.sh" << 'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}
EOF
echo "Created modules/functions.sh"

# --- Create and populate reminder.sh ---
cat > "$DIR_NAME/app/reminder.sh" << 'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ../config/config.env
source ../modules/functions.sh

# Path to the submissions file
submissions_file="../assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions "$submissions_file"
EOF
echo "Created app/reminder.sh"

# --- Create and populate submissions.txt ---
cat > "$DIR_NAME/assets/submissions.txt" << 'EOF'
student,assignment,submission status
Chinemerem,Shell Navigation,not submitted
Chiagoziem,Git,submitted
Divine,Shell Navigation,not submitted
Anissa,Shell Basics,submitted
Lennie,Shell Navigation,not submitted
Christabel,Git,submitted
Alvin,Shell Navigation,not submitted
Annie,Shell Basics,not submitted
Jafar,Shell Navigation,not submitted
EOF
echo "Created assets/submissions.txt"

# --- Create startup.sh ---
cat > "$DIR_NAME/startup.sh" << 'EOF'
#!/bin/bash

# Startup script for Submission Reminder App

# Get the directory this script is in
DIR_NAME="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Navigate to the app directory relative to the script
cd "$DIR_NAME/app" || exit

# Run the reminder script
./reminder.sh
EOF
echo "Created startup.sh"

# --- Make all .sh files executable ---
chmod +x "$DIR_NAME/app/reminder.sh" "$DIR_NAME/modules/functions.sh" "$DIR_NAME/startup.sh"
echo "Set executable permissions for all .sh files"

# --- Test the application by running startup.sh ---
echo "Testing the application by running startup.sh..."
bash "$DIR_NAME/startup.sh" || {
  echo "Error: Failed to run startup.sh"
  exit 1
}
echo "Environment setup and test completed successfully."
