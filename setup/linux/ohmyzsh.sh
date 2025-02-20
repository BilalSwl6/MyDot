#!/bin/bash

OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"

# Function to remove .oh-my-zsh if it exists
remove_oh_my_zsh() {
    if [ -d "$OH_MY_ZSH_DIR" ]; then
        echo "Deleting existing .oh-my-zsh directory..."
        rm -rf "$OH_MY_ZSH_DIR" && echo ".oh-my-zsh deleted successfully."
    else
        echo ".oh-my-zsh directory does not exist, skipping deletion."
    fi
}

# Function to install Oh My Zsh
install_oh_my_zsh() {
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Function to check if Oh My Zsh is installed
is_installed() {
    if [ -d "$OH_MY_ZSH_DIR" ]; then
        return 0  # Oh My Zsh is installed
    else
        return 1  # Oh My Zsh is not installed
    fi
}

# Main function
main() {
    if is_installed; then
        echo "Oh My Zsh is already installed. Skipping installation."
    else
        install_oh_my_zsh
    fi
}

# Execute the main function
main
