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

    # Write the updated content back to .zshrc
    with open(zshrc_path, "w") as file:
        file.writelines(lines)

    print(f"Updated {zshrc_path} with new ZSH_THEME and plugins.")

# Main function
def main():
    edit_zshrc()

if __name__ == "__main__":
    main()
