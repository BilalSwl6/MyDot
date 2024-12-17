#!/bin/bash

# Function to check and install Python
install_python() {
    echo "Checking for Python installation..."
    if command -v python3 &>/dev/null; then
        echo "Python is already installed."
    else
        echo "Python is not installed. Installing Python..."
        if [ -d "/data/data/com.termux" ]; then
            pkg update -y && pkg install python -y
        else
            sudo apt update -y && sudo apt install python3 -y
        fi
        echo "Python installation complete."
    fi
}

# Main script logic
echo "Do you want to run the Python setup script (setup.py)? (yes/no)"
read -r choice

if [[ "$choice" == "yes" ]]; then
    install_python
    echo "Running Python script setup.py..."
    python3 setup/setup.py
    if [[ $? -ne 0 ]]; then
        echo "Error: Python script failed to execute."
        exit 1
    fi
else
    echo "Running alternative Bash script (setup.sh)..."
    if [ -f ".setup/setup.sh" ]; then
        chmod +x setup/setup.sh
        ./setup/setup.sh
    else
        echo "Error: setup.sh not found!"
        exit 1
    fi
fi

echo "Script execution complete."
