#!/bin/bash

# Update and upgrade existing packages
apt update && apt upgrade -y

# Displaying setup size
echo "Installing 2.5GB setup..."

# Install necessary packages
apt install -y git tur-repo fzf fd zoxide eza python nodejs neovim \
stylua lua-language-server lazygit bat gh cmake ripgrep rust ruff \
zsh curl termux-api

echo "Necessary packages installed."

# Update and upgrade again to ensure everything is up-to-date
echo "Updating package lists..."
apt update && apt upgrade -y

# Install Python packages
echo "Installing Python packages..."
pip install markdown-live-preview

# Setup GitHub authentication
echo "Setting up Git..."
gh auth login

# Clone dotFiles repository
gh repo clone abrarishere/dotFiles

# Install ZSH using Zap
echo "Installing and configuring ZSH with Zap..."
zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1

# Replace existing .zshrc with the one from dotFiles
rm -rf ~/.zshrc
cp ~/dotFiles/.zshrc-zap ~/.zshrc
source ~/.zshrc
echo "ZSH setup complete."

# Switch default shell to ZSH
echo 'Switching to ZSH...'
echo "Type 'zsh' if it prompts you to switch to ZSH, otherwise continue with Bash."
chsh

# Set Termux fonts and colors from dotFiles
echo "Setting fonts and colors for Termux..."
rm -rf ~/.termux
cp -r ~/dotFiles/.termux ~/
termux-reload-settings  # Reload Termux settings

# Set up Git username and email
echo "Input your Git username:"
read username
echo "Input your Git email:"
read email
git config --global user.name "$username"
git config --global user.email "$email"
echo "Git configured with username: $username and email: $email."

# Set up Neovim configuration
echo "Setting up Neovim..."
rm -rf ~/.config/nvim
cp -r ~/dotFiles/.config/nvim ~/.config/

# Set up bat (cat alternative with syntax highlighting)
echo "Setting up Bat..."
rm -rf ~/.config/bat
cp -r ~/dotFiles/.config/bat ~/.config/
bat cache --build

# Set up fzf-git integration script
echo "Setting up fzf-git..."
cp -r ~/dotFiles/fzf-git.sh ~/

# Clipboard operation (may take a long time)
echo "Setting clipboard content (this may take a while)..."
termux-clipboard-set

# Open Neovim to install plugins
echo "Opening Neovim to install plugins..."
nvim
