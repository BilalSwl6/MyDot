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

# Install a package safely
install_package() {
    local package="$1"
    if [ "$ENV" == "termux" ]; then
        run_command "pkg install -y $package" "Installing $package"
    else
        run_command "sudo apt install -y $package" "Installing $package"
    fi
}

# Prompt user input with default value and input validation
prompt_with_default() {
    local message="$1"
    local default_value="$2"
    while true; do
        read -p "$message [$default_value]: " choice
        if [ -z "$choice" ]; then
            echo "$default_value"
            return
        elif [[ "$choice" == "y" || "$choice" == "n" ]]; then
            echo "$choice"
            return
        else
            echo "Invalid input. Please enter 'y' or 'n'."
        fi
    done
}

# Git setup
git_setup() {
    read -p "Enter your Git username: " username
    read -p "Enter your Git email: " email
    if [ -z "$username" ] || [ -z "$email" ]; then
        echo "Git username and email cannot be empty."
        exit 1
    fi
    run_command "git config --global user.name '$username'" "Setting Git username"
    run_command "git config --global user.email '$email'" "Setting Git email"
}

# Termux-specific setup
termux_setup() {
    if [ "$(prompt_with_default 'Do you want to set up fzf and Neovim configuration?' 'y')" == "y" ]; then
        install_package "fzf"
        echo "Setting up Neovim configuration..."
        mkdir -p ~/.config
        if [ -d "~/MyDot/nvim" ]; then
            run_command "cp -r ~/MyDot/nvim ~/.config/nvim" "Copying Neovim config from MyDot"
        else
            echo "Error: Neovim config not found at ~/MyDot/nvim. Skipping..."
        fi
    fi
}

# Linux-specific setup
linux_setup() {
    if [ "$(prompt_with_default 'Do you want to install Java SDK?' 'n')" == "y" ]; then
        install_package "default-jdk"
    fi

    if [ "$(prompt_with_default 'Do you want to set up Neovim configuration?' 'n')" == "y" ]; then
        echo "Setting up Neovim configuration..."
        mkdir -p ~/.config
        if [ -d "~/MyDot/nvim" ]; then
            run_command "cp -r ~/MyDot/nvim ~/.config/nvim" "Copying Neovim config from MyDot"
        else
            echo "Error: Neovim config not found at ~/MyDot/nvim. Skipping..."
        fi
    fi

    if [ "$(prompt_with_default 'Do you want to install Flutter and Android SDK?' 'n')" == "y" ]; then
        install_package "unzip"
        install_package "libglu1-mesa"
        install_package "openjdk-11-jdk"

        echo "Installing Flutter..."
        run_command "wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.6-stable.tar.xz -O flutter.tar.xz" "Downloading Flutter"
        run_command "tar xf flutter.tar.xz -C ~" "Extracting Flutter"
        run_command "echo 'export PATH=\"\$PATH:\$HOME/flutter/bin\"' >> ~/.bashrc" "Adding Flutter to PATH"

        echo "Setting up Android SDK..."
        android_sdk="$HOME/Android/Sdk"
        mkdir -p "$android_sdk"
        run_command "wget -q https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O cmd-tools.zip" "Downloading Android SDK"
        run_command "unzip -qq cmd-tools.zip -d $android_sdk/cmdline-tools" "Extracting Android SDK"
        run_command "mv $android_sdk/cmdline-tools/cmdline-tools $android_sdk/cmdline-tools/latest" "Renaming Android tools"
        run_command "echo 'export ANDROID_HOME=$android_sdk' >> ~/.bashrc" "Setting ANDROID_HOME"
        run_command "echo 'export PATH=\"\$PATH:\$ANDROID_HOME/emulator:\$ANDROID_HOME/tools:\$ANDROID_HOME/tools/bin:\$ANDROID_HOME/platform-tools\"' >> ~/.bashrc" "Updating PATH"
        echo "Flutter and Android SDK setup complete."
    fi
}

# Zsh setup
setup_zsh() {
    echo "Setting up Zsh and Powerlevel10k..."
    run_command "git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" "Cloning Powerlevel10k"
    run_command 'sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"' "Installing Oh My Zsh"
    run_command "git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" "Installing Zsh syntax highlighting"
    run_command "git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" "Installing Zsh autosuggestions"

    # Set the theme to Powerlevel10k in .zshrc
    echo 'ZSH_THEME="powerlevel10k/powerlevel10k"' >> ~/.zshrc
    echo 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions)' >> ~/.zshrc

    # Set Zsh as the default shell
    run_command "chsh -s $(which zsh)" "Setting Zsh as default shell"
}

# Add aliases to .zshrc for Termux or Linux
add_aliases() {
    zshrc_path="$HOME/.zshrc"

    termux_aliases="
# Termux aliases
alias del='rm -rf'
alias n='nvim'
alias l='ls -a'
alias q='quit'
alias c='clear'
alias p='python'
alias update='apt update'
alias upgrade='apt upgrade'
alias install='apt install'
alias nc='cd ~/.config/nvim/'
alias zc='n ~/.zshrc'
alias pa='source venv/bin/activate'
alias run='python manage.py runserver'
"

    linux_aliases="
# Linux aliases
alias del='rm -rf'
alias n='nvim'
alias l='ls -a'
alias q='quit'
alias c='clear'
alias p='python' # or python3
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
alias install='sudo apt install'
alias nc='cd ~/.config/nvim/'
alias zc='n ~/.zshrc'
alias pa='source venv/bin/activate'
alias run='python manage.py runserver'
"

    # Check if the file exists, then add aliases
    if [ "$ENV" == "termux" ]; then
        echo "$termux_aliases" >> $zshrc_path
    else
        echo "$linux_aliases" >> $zshrc_path
    fi
}

# Main script execution
detect_environment

# Update and upgrade
if [ "$ENV" == "termux" ]; then
    run_command "pkg update -y && pkg upgrade -y" "Updating Termux packages"
else
    run_command "sudo apt update -y && sudo apt upgrade -y" "Updating Linux packages"
fi

# Install common packages
common_packages=("git" "openssh" "wget" "curl" "fzf" "fd" "git-delta" "nodejs" "python" "ripgrep" "build-essential" "zsh" "ruby" "tmux" "zoxide" "bat" "eza" "lazygit")
for package in "${common_packages[@]}"; do
    install_package "$package"
done

# Environment-specific setups
git_setup
if [ "$ENV" == "termux" ]; then
    termux_setup
else
    linux_setup
fi

# Add aliases to .zshrc
add_aliases

# Zsh setup
setup_zsh

echo -e "\nInstallation complete! Please restart your terminal or source your shell configuration file."
