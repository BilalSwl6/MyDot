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

plugins() {
	echo "installing plugins"
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
	git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
	git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
}

# Main function to orchestrate the process
main() {
    remove_oh_my_zsh
    install
    plugins
}

# Execute the main function
main
