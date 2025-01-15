import os

# Define the path to the .zshrc file
zshrc_path = os.path.expanduser("~/.zshrc")

# Function to edit .zshrc file with new configurations
def edit_zshrc():
    # Check if the .zshrc file exists
    if not os.path.exists(zshrc_path):
        print(f"{zshrc_path} does not exist.")
        return

    with open(zshrc_path, "r") as file:
        lines = file.readlines()

    # Modify the ZSH_THEME line
    for i, line in enumerate(lines):
        if line.startswith("ZSH_THEME"):
            lines[i] = 'ZSH_THEME="powerlevel10k/powerlevel10k"\n'
        
        # Modify the plugins line
        if line.startswith("plugins=("):
            lines[i] = 'plugins=(git zsh-syntax-highlighting zsh-autosuggestions you-should-use)\n'

    # Add aliases at the end of the file
    aliases = [
        'alias del="rm -rf"\n',
        'alias n="nvim"\n',
        'alias l="ls -a"\n',
        'alias q="quit"\n',
        'alias c="clear"\n',
        'alias p="python"\n',
        'alias update="apt update"\n',
        'alias upgrade="apt upgrade"\n',
        'alias install="apt install"\n',
        'alias nc="cd ~/.config/nvim/"\n',
        'alias zc="n ~/.zshrc"\n',
        'alias pa="source venv/bin/activate"\n',
        'alias run="python manage.py runserver"\n'
    ]
    lines.extend(aliases)

    # Write the updated content back to .zshrc
    with open(zshrc_path, "w") as file:
        file.writelines(lines)

    print(f"Updated {zshrc_path} with new ZSH_THEME, plugins, and aliases.")

# Main function
def main():
    edit_zshrc()

if __name__ == "__main__":
    main()
