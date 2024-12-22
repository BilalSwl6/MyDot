#!/bin/bash

# Define colors
#
Green='\033[0;32m'
Blue='\033[0;34m'
Cyan='\033[0;36m'

# Move to the home directory
cd ~

# Clone Repo
echo -e "${Green}Cloning neovim config...${NC}"
git clone https://github.com/neovim/neovim.git

# Move to the neovim directory
cd neovim

# Install dependencies
echo -e "${Blue}Installing dependencies...${NC}"
sudo apt-get install ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip

# Build Neovim
#
echo -e "${Cyan}Building Neovim...${NC}"

make CMAKE_BUILD_TYPE=RelWithDebInfo

# Install Neovim

echo -e "${Green}Installing Neovim...${NC}"
sudo make install

# Move to the home directory
cd ~
