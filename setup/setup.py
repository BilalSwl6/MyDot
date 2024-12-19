import os

# Detect environment (Termux or Linux)
def detect_environment():
    if os.path.exists("/data/data/com.termux"):
        print("Detected Termux environment.")
        return "termux"
    else:
        print("Detected Linux environment.")
        return "linux"

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
    print(f"Aliases added to {zshrc_path}.")

# Update Zsh theme and plugins in .zshrc
def update_zsh_theme_and_plugins():
    zshrc_path = os.path.expanduser("~/.zshrc")
    theme = "powerlevel10k/powerlevel10k"
    plugins = "plugins=(git zsh-syntax-highlighting zsh-autosuggestions you-should-use)"

    with open(zshrc_path, "a") as zshrc:
        zshrc.write("\n# Set Zsh theme\n")
        zshrc.write(f'ZSH_THEME="{theme}"\n')
        zshrc.write("\n# Enable plugins\n")
        zshrc.write(f"{plugins}\n")
    print(f"Zsh theme and plugins updated in {zshrc_path}.")

# Main script execution
if __name__ == "__main__":
    ENV = detect_environment()
    add_aliases()
    update_zsh_theme_and_plugins()
    print("\n.zshrc file updated! Please restart your terminal or source your .zshrc file.")
