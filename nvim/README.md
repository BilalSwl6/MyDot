# MyDot Neovim Configuration

A modern, feature-rich Neovim configuration focused on productivity and ease of use.

![Neovim Screenshot](https://raw.githubusercontent.com/1txb1l4l/MyDot/main/screenshot.png)

## Installation

1. **Install Neovim**
   ```bash
   # Follow instructions at https://github.com/neovim/neovim to install
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
   Wait for the initial plugin installation to complete.

5. **Install language servers**
   ```
   :MasonInstall lua-language-server
   ```
   Add any other language servers you need through Mason.

## GitHub Copilot Setup

To enable GitHub Copilot:

```
:Copilot setup
```

Follow the authentication steps to link your GitHub account.

## Key Features

- File explorer with nvim-tree
- Fuzzy finding with Telescope
- LSP support with auto-completion
- Terminal integration
- Git integration
- Theme switching
- Which-key for keybinding discovery

## Keybindings

> **Note:** The leader key is set to `<Space>` and local leader is set to `/`

### Core Navigation

| Keybinding | Description |
|------------|-------------|
| `<leader>?` | Show all keybindings with which-key |

### File Explorer (Nvim-Tree)

| Keybinding | Description |
|------------|-------------|
| `<leader>ee` | Toggle file explorer |
| `<leader>tc` | Collapse all folders in explorer |

### Tab Management

| Keybinding | Description |
|------------|-------------|
| `<leader>tp` | Previous tab |
| `<leader>tn` | Next tab |
| `<leader>tx` | Close current tab |
| `<leader>to` | Open new tab |

### Fuzzy Finding (Telescope)

| Keybinding | Description |
|------------|-------------|
| `<leader>fa` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | Show buffers |
| `<leader>fh` | Help tags |
| `<leader>ff` | Git files |

### Terminal Integration

| Keybinding | Description |
|------------|-------------|
| `<leader>t1` | Toggle Terminal 1 |
| `<leader>t2` | Toggle Terminal 2 |
| `<leader>t3` | Toggle Terminal 3 |
| `<leader>t4` | Toggle Terminal 4 |

### Theme Switching

| Keybinding | Description |
|------------|-------------|
| `<leader>tt` | Toggle VS Code Theme (Dark/Light) |

### LSP Features

| Keybinding | Description |
|------------|-------------|
| `<leader>e` | Open floating diagnostic message |
| `[d` | Go to previous diagnostic message |
| `]d` | Go to next diagnostic message |
| `<leader>q` | Open diagnostics list |
| `gD` | Go to declaration |
| `gd` | Go to definition |
| `K` | Hover documentation |
| `gi` | Go to implementation |
| `<C-k>` | Signature documentation |
| `gr` | Go to references |

### Code Actions & Refactoring

| Keybinding | Description |
|------------|-------------|
| `<leader>D` | Type definition |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action (normal & visual mode) |
| `<leader>f` | Format file |

### Workspace Management

| Keybinding | Description |
|------------|-------------|
| `<leader>wa` | Add workspace folder |
| `<leader>wr` | Remove workspace folder |
| `<leader>wl` | List workspace folders |

### Completion Menu

| Keybinding | Description |
|------------|-------------|
| `<C-b>` | Scroll docs up |
| `<C-f>` | Scroll docs down |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort completion |
| `<CR>` | Confirm completion |
| `<Tab>` | Select next item |
| `<S-Tab>` | Select previous item |

## Customization

The configuration is organized in a modular structure:

- `~/.config/nvim/init.lua` - Main entry point
- `~/.config/nvim/lua/` - Configuration modules

To customize settings, edit the corresponding files in these directories.

## Updating

To update the configuration:

```bash
cd MyDot
git pull
rm -rf ~/.config/nvim
cp -rf nvim ~/.config/nvim
```

## Troubleshooting

If you encounter issues:

1. Update Neovim to the latest version
2. Run `:checkhealth` for diagnostics
3. Try `:Lazy` to update plugins

## Credits

This configuration is maintained by [1txb1l4l](https://github.com/1txb1l4l).
