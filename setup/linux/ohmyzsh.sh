#!/bin/bash

OH_MY_ZSH_DIR="$HOME/.oh-my-zsh"

# Function to delete the .oh-my-zsh directory if it exists
remove_oh_my_zsh() {
    echo "Checking if $OH_MY_ZSH_DIR exists..."
    if [ -d "$OH_MY_ZSH_DIR" ]; then
        echo "Deleting existing .oh-my-zsh directory..."
        rm -rf "$OH_MY_ZSH_DIR" && echo ".oh-my-zsh deleted successfully." || echo "Failed to delete .oh-my-zsh."
    else
        echo ".oh-my-zsh directory does not exist, skipping deletion."
    fi
}

install() {
	echo "installing oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

# Main function to orchestrate the process
main() {
    remove_oh_my_zsh
    install
    plugins
}

# Execute the main function
main
