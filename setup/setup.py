import os
import subprocess
import sys

# Detect Termux or Linux environment
def detect_environment():
    if os.path.exists("/data/data/com.termux"):
        print("Detected Termux environment.")
        return "termux"
    else:
        print("Detected Linux environment.")
        return "linux"

# Run commands with error handling
def run_command(command, description):
    print(f"Running: {description}...")
    try:
        subprocess.run(command, shell=True, check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        print(f"{description} completed successfully.")
    except subprocess.CalledProcessError:
        print(f"Error: {description} failed. Skipping...")

# Install a package safely
def install_package(package):
    if ENV == "termux":
        command = f"pkg install -y {package}"
    else:
        command = f"sudo apt install -y {package}"
    run_command(command, f"Installing {package}")

# Prompt user input with default value and input validation
def prompt_with_default(message, default_value):
    while True:
        choice = input(f"{message} [{default_value}]: ").strip().lower()
        if not choice:
            return default_value
        elif choice in ['y', 'n']:
            return choice
        else:
            print("Invalid input. Please enter 'y' or 'n'.")

# Git setup
def git_setup():
    username = input("Enter your Git username: ").strip()
    email = input("Enter your Git email: ").strip()
    if not username or not email:
        print("Git username and email cannot be empty.")
        sys.exit(1)
    run_command(f"git config --global user.name '{username}'", "Setting Git username")
    run_command(f"git config --global user.email '{email}'", "Setting Git email")

# Termux-specific setup
def termux_setup():
    if prompt_with_default("Do you want to set up fzf and Neovim configuration?", 'y') == 'y':
        install_package("fzf")
        print("Setting up Neovim configuration...")
        os.makedirs(os.path.expanduser("~/.config"), exist_ok=True)
        # Copy Neovim config from MyDot/nvim
        nvim_config_src = os.path.expanduser("~/MyDot/nvim")
        nvim_config_dest = os.path.expanduser("~/.config/nvim")
        if os.path.exists(nvim_config_src):
            run_command(f"cp -r {nvim_config_src} {nvim_config_dest}", "Copying Neovim config from MyDot")
        else:
            print(f"Error: Neovim config not found at {nvim_config_src}. Skipping...")

# Linux-specific setup
def linux_setup():
    if prompt_with_default("Do you want to install Java SDK?", 'n') == 'y':
        install_package("default-jdk")

    if prompt_with_default("Do you want to set up Neovim configuration?", 'n') == 'y':
        print("Setting up Neovim configuration...")
        os.makedirs(os.path.expanduser("~/.config"), exist_ok=True)
        # Copy Neovim config from MyDot/nvim
        nvim_config_src = os.path.expanduser("~/MyDot/nvim")
        nvim_config_dest = os.path.expanduser("~/.config/nvim")
        if os.path.exists(nvim_config_src):
            run_command(f"cp -r {nvim_config_src} {nvim_config_dest}", "Copying Neovim config from MyDot")
        else:
            print(f"Error: Neovim config not found at {nvim_config_src}. Skipping...")

    if prompt_with_default("Do you want to install Flutter and Android SDK?", 'n') == 'y':
        install_package("unzip")
        install_package("libglu1-mesa")
        install_package("openjdk-11-jdk")

        print("Installing Flutter...")
        run_command("wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.10.6-stable.tar.xz -O flutter.tar.xz", "Downloading Flutter")
        run_command("tar xf flutter.tar.xz -C ~", "Extracting Flutter")
        run_command("echo 'export PATH=\"$PATH:$HOME/flutter/bin\"' >> ~/.bashrc", "Adding Flutter to PATH")

        print("Setting up Android SDK...")
        android_sdk = os.path.expanduser("~/Android/Sdk")
        os.makedirs(android_sdk, exist_ok=True)
        run_command("wget -q https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -O cmd-tools.zip", "Downloading Android SDK")
        run_command(f"unzip -qq cmd-tools.zip -d {android_sdk}/cmdline-tools", "Extracting Android SDK")
        run_command(f"mv {android_sdk}/cmdline-tools/cmdline-tools {android_sdk}/cmdline-tools/latest", "Renaming Android tools")
        run_command(f"echo 'export ANDROID_HOME={android_sdk}' >> ~/.bashrc", "Setting ANDROID_HOME")
        run_command(f"echo 'export PATH=\"$PATH:$ANDROID_HOME/emulator:$ANDROID_HOME/tools:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools\"' >> ~/.bashrc", "Updating PATH")
        print("Flutter and Android SDK setup complete.")

# Zsh setup
def setup_zsh():
    print("Setting up Zsh and Powerlevel10k...")
    # Clone Powerlevel10k and Oh My Zsh setup
    run_command("git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k", "Cloning Powerlevel10k")
    run_command('sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"', "Installing Oh My Zsh")
    run_command("git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting", "Installing Zsh syntax highlighting")
    run_command("git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions", "Installing Zsh autosuggestions")

    # Set the theme to Powerlevel10k in .zshrc
    zshrc_path = os.path.expanduser("~/.zshrc")
    with open(zshrc_path, "a") as zshrc:
        zshrc.write('\n# Set Powerlevel10k theme\n')
        zshrc.write('ZSH_THEME="powerlevel10k/powerlevel10k"\n')
        zshrc.write('\n# Enable plugins\n')
        zshrc.write('plugins=(git zsh-syntax-highlighting zsh-autosuggestions)\n')


# Add aliases to .zshrc for Termux or Linux
def add_aliases():
    zshrc_path = os.path.expanduser("~/.zshrc")

    termux_aliases = """
# Termux aliases
alias del='rm -rf'
alias n="nvim"
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
"""
    linux_aliases = """
# Linux aliases
alias del='rm -rf'
alias n="nvim"
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
"""

    # Check if the file exists, then add aliases
    with open(zshrc_path, "a") as zshrc:
        if ENV == "termux":
            zshrc.write(termux_aliases)
        else:
            zshrc.write(linux_aliases)

# Main script execution
if __name__ == "__main__":
    ENV = detect_environment()

    # Update and upgrade
    if ENV == "termux":
        run_command("pkg update -y && pkg upgrade -y", "Updating Termux packages")
    else:
        run_command("sudo apt update -y && sudo apt upgrade -y", "Updating Linux packages")

    # Install common packages
    common_packages = ["git", "openssh", "wget", "curl", "fzf", "fd", "git-delta",
                       "nodejs", "python", "ripgrep", "build-essential", "zsh", "ruby",
                       "tmux", "zoxide", "bat", "eza", "lazygit"]
    for package in common_packages:
        install_package(package)

    # Environment-specific setups
    git_setup()
    if ENV == "termux":
        termux_setup()
    else:
        linux_setup()

    # Add aliases to .zshrc
    add_aliases()

    # Zsh setup
    setup_zsh()

    print("\nInstallation complete! Please restart your terminal or source your shell configuration file.")
