#!/bin/bash

# Variables
NEOVIM_URL="https://github.com/neovim/neovim/releases/download/v0.10.3/nvim-linux64.tar.gz"
INSTALL_DIR="$HOME/.local"
NVIM_DIR="$INSTALL_DIR/nvim-linux64"
PROFILE_FILE="$HOME/.zshrc"

# Functions
function add_to_path() {
  if ! grep -q "$NVIM_DIR/bin" "$PROFILE_FILE"; then
    echo "Adding Neovim to PATH in $PROFILE_FILE..."
    echo "export PATH=\"$NVIM_DIR/bin:\$PATH\"" >> "$PROFILE_FILE"
    source "$PROFILE_FILE"
  fi
}

# Step 1: Download Neovim
echo "Downloading Neovim from $NEOVIM_URL..."
curl -L "$NEOVIM_URL" -o nvim-linux64.tar.gz || {
  echo "Error downloading Neovim!"
  exit 1
}

# Step 2: Extract the tarball
echo "Extracting Neovim..."
mkdir -p "$INSTALL_DIR"
tar -xzf nvim-linux64.tar.gz -C "$INSTALL_DIR" || {
  echo "Error extracting Neovim!"
  exit 1
}

# Step 3: Add Neovim to PATH
add_to_path

# Step 4: Verify Installation
echo "Verifying Neovim installation..."
if command -v nvim &>/dev/null; then
  echo "Neovim installed successfully!"
  nvim --version
else
  echo "Neovim installation failed!"
  exit 1
fi

# Step 5: Clean up
echo "Cleaning up..."
rm -f nvim-linux64.tar.gz

echo "Installation complete! Restart your shell or source your profile file to use Neovim."
