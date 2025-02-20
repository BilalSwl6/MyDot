#!/bin/bash


# Permissions For All Files
chmod +x *
echo "Permissions Granted."

# Run All Scripts
echo "Running all scripts..."
. ~/MyDot/setup/linux/packages.sh
. ~/MyDot/setup/linux/ohmyzsh.sh
. ~/MyDot/setup/linux/pluginzs.sh
. ~/MyDot/setup/linux/nvim.sh

# Python Scripts
echo "Running Python scripts..."
python3 ~/MyDot/setup/linux/nvim-set.py
python3 ~/MyDot/setup/linux/zsh-setup.py

