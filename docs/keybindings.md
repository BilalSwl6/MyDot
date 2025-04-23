# Keybindings Reference

This page provides a comprehensive list of keybindings available in MyDot Neovim configuration.

> **Note:** The leader key is set to `<Space>` and local leader is set to `/`

## Core Navigation

| Keybinding | Description |
|------------|-------------|
| `<leader>?` | Show all keybindings with which-key |

## File Explorer (Nvim-Tree)

| Keybinding | Description |
|------------|-------------|
| `<leader>ee` | Toggle file explorer |
| `<leader>tc` | Collapse all folders in explorer |

## Tab Management

| Keybinding | Description |
|------------|-------------|
| `<leader>tp` | Previous tab |
| `<leader>tn` | Next tab |
| `<leader>tx` | Close current tab |
| `<leader>to` | Open new tab |

## Fuzzy Finding (Telescope)

| Keybinding | Description |
|------------|-------------|
| `<leader>fa` | Find files |
| `<leader>fg` | Live grep (search in files) |
| `<leader>fb` | Show buffers |
| `<leader>fh` | Help tags |
| `<leader>ff` | Git files |

## Terminal Integration

| Keybinding | Description |
|------------|-------------|
| `<leader>t1` | Toggle Terminal 1 |
| `<leader>t2` | Toggle Terminal 2 |
| `<leader>t3` | Toggle Terminal 3 |
| `<leader>t4` | Toggle Terminal 4 |

## Theme Switching

| Keybinding | Description |
|------------|-------------|
| `<leader>tt` | Toggle VS Code Theme (Dark/Light) |

## LSP Features

| Keybinding | Description |a
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

## Code Actions & Refactoring

| Keybinding | Description |
|------------|-------------|
| `<leader>D` | Type definition |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action (normal & visual mode) |
| `<leader>f` | Format file |

## Workspace Management

| Keybinding | Description |
|------------|-------------|
| `<leader>wa` | Add workspace folder |
| `<leader>wr` | Remove workspace folder |
| `<leader>wl` | List workspace folders |

## Completion Menu

| Keybinding | Description |
|------------|-------------|
| `<C-b>` | Scroll docs up |
| `<C-f>` | Scroll docs down |
| `<C-Space>` | Trigger completion |
| `<C-e>` | Abort completion |
| `<CR>` | Confirm completion |
| `<Tab>` | Select next item |
| `<S-Tab>` | Select previous item |

## Custom File Explorer Bindings

When the file explorer (nvim-tree) is focused, these additional keys are available:

| Keybinding | Description |
|------------|-------------|
| `<CR>` or `o` | Open file |
| `a` | Create new file |
| `d` | Delete file/directory |
| `r` | Rename file/directory |
| `x` | Cut file/directory |
| `c` | Copy file/directory |
| `p` | Paste file/directory |
| `R` | Refresh explorer |
| `H` | Toggle hidden files |

## Git Related Commands

| Keybinding | Description |
|------------|-------------|
| `<leader>g` | Opens the git submenu |
| `<leader>gg` | Opens lazygit in a floating terminal |
| `<leader>gc` | Git commits (requires Telescope) |
| `<leader>gs` | Git status (requires Telescope) |

[← Back to Home](index.html)
