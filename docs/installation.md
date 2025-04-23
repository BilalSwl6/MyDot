# Installation Guide

Setting up MyDot Neovim configuration is straightforward. Follow these steps to get started.

## Prerequisites

- Neovim 0.8.0 or higher
- Git
- A terminal with true color support
- (Optional) Nerd Font for icons

## Installation Steps

1. **Install Neovim**
   ```bash
   # On macOS
   brew install neovim

   # On Ubuntu/Debian
   sudo apt install neovim

   # On Arch Linux
   sudo pacman -S neovim
   
   # For other systems or to build from source
   # Follow instructions at https://github.com/neovim/neovim
   ```

2. **Clone the repository**
   ```bash
   git clone https://github.com/1txb1l4l/MyDot
   ```

3. **Install the configuration**
   ```bash
   # Backup existing configuration if needed
   rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim
   
   # Copy new configuration
   cd MyDot
   cp -rf nvim ~/.config/nvim
   ```

4. **Launch Neovim**
   ```bash
   nvim
   ```
   The first time you launch Neovim with this configuration, it will automatically:
   - Install the plugin manager (Lazy.nvim)
   - Download and install all configured plugins
   - Set up the basic environment

   This process might take a few minutes. Wait for it to complete.

5. **Install language servers**
   
   MyDot uses Mason to manage LSP servers. To install language servers:
   
   ```
   :MasonInstall lua-language-server
   ```
   
   You can install additional language servers based on your needs:
   ```
   :MasonInstall pyright typescript-language-server rust-analyzer gopls
   ```

## GitHub Copilot Setup

To enable GitHub Copilot:

1. Run the setup command inside Neovim:
   ```
   :Copilot setup
   ```

2. Follow the authentication steps to link your GitHub account.

3. After authentication, you can enable Copilot in the current buffer:
   ```
   :Copilot enable
   ```

## Updating

To update the configuration to the latest version:

```bash
cd MyDot
git pull
rm -rf ~/.config/nvim
cp -rf nvim ~/.config/nvim
```

Then restart Neovim and run `:Lazy update` to update all plugins.

## Next Steps

- Check out the [Keybindings Reference](keybindings.html) to learn the essential shortcuts
- Explore available [Plugins](plugins.html) included in the configuration
- Learn how to [Customize](customization.html) the setup for your needs

[← Back to Home](index.html)
