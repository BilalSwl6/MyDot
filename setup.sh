#!/bin/bash

# Function to detect Termux
is_termux() {
    if [ -d "$HOME/.termux" ]; then
        echo "Termux detected."
        return 0  # true
    else
        return 1  # false
    fi
}

# Function to detect Linux
is_linux() {
    if [[ "$(uname)" == "Linux" ]]; then
        echo "Linux detected."
        return 0  # true
    else
        return 1  # false
    fi
}

# Main function to execute OS-specific tasks
main() {
    if is_termux; then
        echo "Running commands for Termux..."
	pkg update
	pkg upgrade
	pkg install curl wget git python python-pip
	chmod +x setup/termux/init.sh
	./setup/termux/init.sh
    elif is_linux; then
        echo "Running commands for Linux..."
        sudo apt update
	sudo apt upgrade -y
	sudo apt install curl wget git python3 python3-pip -y
	chmod +x setup/linux/init.sh
	./setup/linux/init.sh
    else
        echo "Unknown OS detected."
	echo "Still Not Working."
    fi
}

# Execute the main function
main
