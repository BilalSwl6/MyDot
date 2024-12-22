#!/bin/bash

sudo apt update
sudo apt upgrade
sudo apt install curl wget git python3 python3-pip fzf zsh tmux golang cmake 


# Permissions For All Files
chmod +x *


# Run All Scripts
./ohmyzsh.sh
./packages.sh
./ohmyzsh.sh
./nvim.sh

# Python Scripts
python zsh-setup.py
python nvim-set.py


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

