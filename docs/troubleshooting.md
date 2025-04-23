# Troubleshooting

This page provides solutions to common issues you might encounter with MyDot Neovim configuration.

## General Troubleshooting Steps

When you encounter issues, try these general troubleshooting steps first:

1. **Update Neovim to the latest version**
   ```bash
   # For macOS
   brew upgrade neovim
   
   # For Ubuntu/Debian (if installed via PPA)
   sudo apt update && sudo apt upgrade
   
   # For Arch Linux
   sudo pacman -Syu
   ```

2. **Run Neovim's health check**
   ```
   :checkhealth
   ```
   This command runs diagnostics and identifies issues with your setup.

3. **Update plugins**
   ```
   :Lazy update
   ```

4. **Sync plugin installations**
   ```
   :Lazy sync
   ```

## Common Issues and Solutions

### Plugin Manager Issues

**Issue: Lazy.nvim fails to install**

Solution:
1. Check your internet connection
2. Ensure Git is properly installed and in your PATH
3. Try manually cloning the repository:
   ```bash
   git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable ~/.local/share/nvim/lazy/lazy.nvim
   ```

### LSP Related Issues

**Issue: Language server not working**

Solution:
1. Ensure the language server is installed:
   ```
   :Mason
   ```
   Look for the language server in the list and press `i` to install if needed.

2. Check if the language server is properly configured:
   ```
   :LspInfo
   ```
   This shows information about the active language servers.

3. Verify that your file is recognized as the correct filetype:
   ```
   :set filetype?
   ```

**Issue: LSP completion not working**

Solution:
1. Make sure nvim-cmp is properly installed:
   ```
   :Lazy check nvim-cmp
   ```

2. Verify that the language server is properly attached to the buffer:
   ```
   :LspInfo
   ```

3. Try restarting the language server:
   ```
   :LspRestart
   ```

### Treesitter Issues

**Issue: Syntax highlighting not working properly**

Solution:
1. Install the treesitter parser for your language:
   ```
   :TSInstall <language>
   ```
   Replace `<language>` with the language you're using (e.g., `python`, `lua`).

2. If that doesn't help, try updating all parsers:
   ```
   :TSUpdate
   ```

### Performance Issues

**Issue: Neovim is slow to start**

Solution:
1. Identify which plugins are causing the slowdown:
   ```
   :Lazy profile
   ```

2. Consider disabling heavy plugins that you don't frequently use by editing `~/.config/nvim/lua/plugins/init.lua`.

3. Check if you have too many treesitter parsers installed:
   ```
   :TSModuleInfo
   ```
   Consider uninstalling parsers for languages you don't use.

### File Explorer Issues

**Issue: NvimTree file explorer not showing icons**

Solution:
1. Ensure you have a patched Nerd Font installed and configured in your terminal
2. Verify that nvim-web-devicons is installed:
   ```
   :Lazy check nvim-web-devicons
   ```

### Colorscheme Issues

**Issue: Colors don't look right**

Solution:
1. Check if your terminal supports true color:
   ```
   :checkhealth nvim
   ```

2. Add the following to your configuration if needed:
   ```lua
   -- In ~/.config/nvim/lua/core/options.lua
   vim.opt.termguicolors = true
   ```

3. If using tmux, ensure your tmux configuration has true color support:
   ```
   # Add to ~/.tmux.conf
   set -g default-terminal "tmux-256color"
   set -ga terminal-overrides ",*256col*:Tc"
   ```

### Copilot Issues

**Issue: GitHub Copilot not working**

Solution:
1. Make sure you're logged in:
   ```
   :Copilot status
   ```

2. If not authenticated, run:
   ```
   :Copilot setup
   ```

3. Try enabling Copilot for the current buffer:
   ```
   :Copilot enable
   ```

## Resetting Your Configuration

If you encounter persistent issues, you might want to reset your configuration:

1. **Backup your current settings**
   ```bash
   cp -r ~/.config/nvim ~/.config/nvim.bak
   ```

2. **Clean Neovim data and state directories**
   ```bash
   rm -rf ~/.local/share/nvim ~/.local/state/nvim
   ```

3. **Reinstall the configuration**
   ```bash
   rm -rf ~/.config/nvim
   cd MyDot
   cp -rf nvim ~/.config/nvim
   ```

## Getting Additional Help

If you're still experiencing issues:

1. **Check the Issue tracker on GitHub**
   Browse existing issues at https://github.com/1txb1l4l/MyDot/issues to see if your problem has been reported.

2. **Open a new issue**
   If your problem hasn't been reported, open a new issue with:
   - A clear description of the problem
   - Steps to reproduce
   - Output of `:checkhealth`
   - Your Neovim version (`nvim --version`)

3. **Join the community**
   Reach out on platforms where Neovim users gather:
   - [Neovim Discord](https://discord.gg/neovim)
   - [Neovim subreddit](https://www.reddit.com/r/neovim/)

[← Back to Home](index.html)
