# Submission Reminder System

This app helps you keep track of student assignment submissions using simple commands. It makes it easy to see who needs a reminder about their work.

## How It's Set Up

The app uses a clear folder structure. When you set it up (for example, from a folder named `submission_reminder_Lennie` and you enter `José` as your name), here's how the files will be arranged:

```
submission_reminder_Lennie/
├── copilot_shell_script.sh
├── create_environment.sh
├── README.md
└── submission_reminder_{YourName}/  # This is your personal app folder
    ├── app/
    │   └── reminder.sh              # The main part of the reminder
    ├── modules/
    │   └── functions.sh             # Useful tools and functions
    ├── assets/
    │   └── submissions.txt          # Where student data is stored
    ├── config/
    │   └── config.env               # App settings 
    └── startup.sh                   # Starts the reminder process inside your app folder
```

## What Each Part Does

Each file and folder has a clear job:

* **`copilot_shell_script.sh`**: This is how you control the app. You use it to choose your project, tell the app which assignment to check, update its settings, and start the reminder process.

* **`create_environment.sh`**: This script helps you get started. Run it once, and it will build your project folder (`submission_reminder_{YourName}/`) and put all the necessary files inside.

* **`submission_reminder_{YourName}/`**: This is your dedicated app folder. Inside it, you will find:
    * **`app/reminder.sh`**: This script gets assignment details and uses `check_submissions` to show you who needs a reminder.
    * **`modules/functions.sh`**: A set of shared functions. The main one is `check_submissions`, which processes your student data.
    * **`assets/submissions.txt`**: This file holds your student list and their submission status. It's a simple text file, like `Chinemerem,Shell Navigation,not submitted`.
    * **`config/config.env`**: This file stores important settings, such as the `ASSIGNMENT` you are tracking and `DAYS_REMAINING`.
    * **`startup.sh`**: This script starts the reminder process within your app folder. It is usually run by `copilot_shell_script.sh`.

## What You Need

Here are the basic requirements to run the app:

* **Operating System:** Linux.
* **Permissions:** You need permission to create and change files in the folder where you set up the app (e.g., `submission_reminder_Lennie`).

## How to Get Started

Follow these steps to set up and run the reminder system:

1.  **Get the Scripts:** Make sure you have `create_environment.sh` and `copilot_shell_script.sh` in your current folder.

2.  **Set Up the App:**
    ```bash
    chmod +x create_environment.sh
    ./create_environment.sh
    ```
    This script will ask for your name (like `José`) and then set up your `submission_reminder_{José}/` folder.

3.  **Run the App:**
    ```bash
    chmod +x copilot_shell_script.sh
    ./copilot_shell_script.sh
    ```
    This command will ask you to pick your project, tell it which assignment to watch, and then start the reminder process.
