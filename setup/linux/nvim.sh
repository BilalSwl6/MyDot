#!/bin/bash

# Set variables
NVIM_VERSION_URL="https://api.github.com/repos/neovim/neovim/releases/latest"
INSTALL_DIR="/usr/local/bin"

# Function to check if curl is installed
check_curl() {
    if ! command -v curl &> /dev/null; then
        echo "curl is not installed. Installing curl..."
        sudo apt update && sudo apt install curl -y
    fi
}

# Function to check if tar is installed
check_tar() {
    if ! command -v tar &> /dev/null; then
        echo "tar is not installed. Installing tar..."
        sudo apt update && sudo apt install tar -y
    fi
}

# Function to download and install Neovim
install_neovim() {
    echo "Fetching the latest release of Neovim..."

    # Get the latest release information
    release_data=$(curl -s $NVIM_VERSION_URL)
    download_url=$(echo $release_data | jq -r '.assets[] | select(.name | test("linux64.tar.gz")) | .browser_download_url')

    if [ -z "$download_url" ]; then
        echo "Could not find a suitable release for Linux. Exiting."
        exit 1
    fi

    echo "Downloading Neovim from $download_url..."

    # Download the tarball
    curl -L -o nvim.tar.gz "$download_url"

    echo "Extracting Neovim..."

    # Extract the tarball
    tar -xvzf nvim.tar.gz

    echo "Installing Neovim..."

    # Move the extracted files to /usr/local/bin
    sudo mv nvim-linux64 /usr/local/bin/nvim

    echo "Cleaning up..."

    # Remove the downloaded tarball
    rm -rf nvim.tar.gz

    echo "Neovim installation complete."
}

# Main function
main() {
    check_curl
    check_tar
    install_neovim
}

# Run the main function
main
