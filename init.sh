#!/bin/bash

# Define colors
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
RED='\033[0;31m'
NC='\033[0m' # No color

echo -e "${CYAN}Running Setup${NC}"

# Set execute permissions
echo -e "${YELLOW}Setting execute permissions for setup scripts...${NC}"
chmod +x setup/setup.sh
chmod +x setup/setup.py

# Run the shell script
echo -e "${GREEN}Executing setup.sh...${NC}"
./setup/setup.sh

# Ask to run the Python script
while true; do
    echo -e "${BLUE}Do you want to run the Python script (setup.py)? (y/n):${NC}"
    read -p "> " choice
    case "$choice" in
        y|Y) 
            echo -e "${GREEN}Executing setup.py...${NC}"
            ./setup/setup.py
            break
            ;;
        n|N) 
            echo -e "${RED}Skipping setup.py execution.${NC}"
            break
            ;;
        *) 
            echo -e "${RED}Invalid input. Please enter 'y' or 'n'.${NC}"
            ;;
    esac
done

echo -e "${CYAN}Setup Complete!${NC}"
