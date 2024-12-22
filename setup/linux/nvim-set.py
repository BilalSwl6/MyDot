import os
import shutil

# Define the paths
nvim_config_path = os.path.expanduser("~/.config/nvim")
source_folder_path = "~/MyDot/nvim/"  # Change this to the path of your source folder

# Function to delete the Neovim config folder if it exists
def delete_nvim_config():
    if os.path.exists(nvim_config_path):
        print(f"Deleting existing Neovim config at {nvim_config_path}...")
        shutil.rmtree(nvim_config_path)  # Recursively delete the folder
    else:
        print(f"No existing Neovim config found at {nvim_config_path}. Skipping deletion.")

# Function to copy the folder to the .config directory
def copy_nvim_config():
    print(f"Copying new configuration from {source_folder_path} to {nvim_config_path}...")
    shutil.copytree(source_folder_path, nvim_config_path)  # Recursively copy the folder

# Main function
def main():
    delete_nvim_config()
    copy_nvim_config()
    print("Neovim configuration updated successfully.")

# Run the script
if __name__ == "__main__":
    main()
