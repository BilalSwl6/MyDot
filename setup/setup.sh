#!/bin/bash

# Detect Termux or Linux environment
detect_environment() {
    if [ -d "/data/data/com.termux" ]; then
        echo "Detected Termux environment."
        ENV="termux"
    else
        echo "Detected Linux environment."
        ENV="linux"
    fi
}

# Run commands with error handling
run_command() {
    local command="$1"
    local description="$2"
    echo "Running: $description..."
    if $command; then
        echo "$description completed successfully."
    else
        echo "Error: $description failed. Skipping..."
    fi
}

# Confirm before proceeding
confirm_step() {
    local message="$1"
    while true; do
        read -p "$message (y/n): " choice
        case "$choice" in
            y|Y) return 0 ;;
            n|N) return 1 ;;
            *) echo "Invalid input. Please enter 'y' or 'n'." ;;
        esac
    done
}

# Install a package safely
install_package() {
    local package="$1"
    if confirm_step "Do you want to install $package?"; then
        if [ "$ENV" == "termux" ]; then
            run_command "pkg install -y $package" "Installing $package"
        else
            run_command "sudo apt install -y $package" "Installing $package"
        fi
    else
        echo "Skipped installing $package."
    fi
}

# Zsh setup without editing files
setup_zsh() {
    if confirm_step "Do you want to set up Zsh and Powerlevel10k?"; then
        echo "Setting up Zsh and Powerlevel10k..."

        # Remove existing Oh My Zsh if it exists
        if [ -d "$HOME/.oh-my-zsh" ]; then
            if confirm_step "Oh My Zsh is already installed. Do you want to remove and reinstall it?"; then
                run_command "rm -rf $HOME/.oh-my-zsh" "Removing existing Oh My Zsh"
            else
                echo "Skipped removing Oh My Zsh."
                return
            fi
        fi

        # Install Oh My Zsh
        run_command 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"' "Installing Oh My Zsh"

        # Install Powerlevel10k
        run_command "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" "Cloning Powerlevel10k"

        # Install Zsh plugins
        run_command "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" "Installing Zsh syntax highlighting"
        run_command "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" "Installing Zsh autosuggestions"
        run_command "git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use" "Installing you-should-use plugin"
    else
        echo "Skipped Zsh setup."
    fi
}

# Check and configure Git username and email
check_git_config() {
    local username=$(git config --global user.name)
    local email=$(git config --global user.email)

    echo "Checking Git configuration..."
    if [ -n "$username" ] && [ -n "$email" ]; then
        echo "Git is already configured with:"
        echo "Username: $username"
        echo "Email: $email"
    else
        echo "Git username and/or email are not configured."
        if confirm_step "Do you want to configure Git now?"; then
            read -p "Enter your Git username: " new_username
            read -p "Enter your Git email: " new_email

            run_command "git config --global user.name \"$new_username\"" "Setting Git username"
            run_command "git config --global user.email \"$new_email\"" "Setting Git email"
        else
            echo "Skipped Git configuration."
        fi
    fi
}

# Main script execution
detect_environment

# Update and upgrade
if confirm_step "Do you want to update and upgrade packages?"; then
    if [ "$ENV" == "termux" ]; then
        run_command "pkg update -y && pkg upgrade -y" "Updating Termux packages"
    else
        run_command "sudo apt update -y && sudo apt upgrade -y" "Updating Linux packages"
    fi
else
    echo "Skipped update and upgrade."
fi

# Install common packages
common_packages=("git" "openssh" "wget" "curl" "fzf" "gh" "nodejs" "python" "ripgrep" "build-essential" "zsh" "ruby" "tmux" "zoxide" "lazygit")
for package in "${common_packages[@]}"; do
    install_package "$package"
done

# Check Git configuration
check_git_config

# Zsh setup
setup_zsh

echo -e "\nSetup complete! Please restart your terminal or source your shell configuration file."
