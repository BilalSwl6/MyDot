#!/bin/bash


# Permissions For All Files
chmod +x *
echo "Permissions Granted."

# Run All Scripts
echo "Running all scripts..."
. ~/MyDot/setup/linux/packages.sh
. ~/MyDot/setup/linux/ohmyzsh.sh
. ~/MyDot/setup/linux/nvim.sh

# Python Scripts
echo "Running Python scripts..."
python3 ~/MyDot/setup/linux/nvim-set.py
python3 ~/MyDot/setup/linux/zsh-setup.py

# Git Values
check_git_config() {
    local username=$(git config --global user.name)
    local email=$(git config --global user.email)

    echo "Checking Git configuration..."
    if [ -n "$username" ] && [ -n "$email" ]; then
        echo "Git is already configured with:"
        echo "Username: $username"
        echo "Email: $email"
    else
        echo "Git username and/or email are not configured."
        if confirm_step "Do you want to configure Git now?"; then
            read -p "Enter your Git username: " new_username
            read -p "Enter your Git email: " new_email

            run_command "git config --global user.name \"$new_username\"" "Setting Git username"
            run_command "git config --global user.email \"$new_email\"" "Setting Git email"
        else
            echo "Skipped Git configuration."
        fi
    fi
}

check_git_config
