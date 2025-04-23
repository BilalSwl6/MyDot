# Plugin List

MyDot Neovim configuration comes with a carefully selected set of plugins to enhance your development experience. All plugins are managed by [lazy.nvim](https://github.com/folke/lazy.nvim), a modern plugin manager for Neovim.

## Core Plugins

### Plugin Management
- [folke/lazy.nvim](https://github.com/folke/lazy.nvim) - A modern plugin manager for Neovim

### User Interface
- [nvim-tree/nvim-tree.lua](https://github.com/nvim-tree/nvim-tree.lua) - File explorer
- [nvim-lualine/lualine.nvim](https://github.com/nvim-lualine/lualine.nvim) - Statusline
- [akinsho/bufferline.nvim](https://github.com/akinsho/bufferline.nvim) - Buffer line with tabs
- [lukas-reineke/indent-blankline.nvim](https://github.com/lukas-reineke/indent-blankline.nvim) - Indentation guides
- [folke/which-key.nvim](https://github.com/folke/which-key.nvim) - Keybinding hints

### Colorschemes
- [Mofiqul/vscode.nvim](https://github.com/Mofiqul/vscode.nvim) - VS Code-like theme

### Navigation and Search
- [nvim-telescope/telescope.nvim](https://github.com/nvim-telescope/telescope.nvim) - Fuzzy finder
- [nvim-telescope/telescope-fzf-native.nvim](https://github.com/nvim-telescope/telescope-fzf-native.nvim) - FZF sorter for Telescope

### Terminal Integration
- [akinsho/toggleterm.nvim](https://github.com/akinsho/toggleterm.nvim) - Terminal management

## Development Tools

### LSP and Completion
- [neovim/nvim-lspconfig](https://github.com/neovim/nvim-lspconfig) - Configurations for Neovim LSP
- [williamboman/mason.nvim](https://github.com/williamboman/mason.nvim) - Package manager for LSP servers
- [williamboman/mason-lspconfig.nvim](https://github.com/williamboman/mason-lspconfig.nvim) - Bridge between mason and lspconfig
- [hrsh7th/nvim-cmp](https://github.com/hrsh7th/nvim-cmp) - Completion engine
- [hrsh7th/cmp-nvim-lsp](https://github.com/hrsh7th/cmp-nvim-lsp) - LSP source for nvim-cmp
- [hrsh7th/cmp-buffer](https://github.com/hrsh7th/cmp-buffer) - Buffer source for nvim-cmp
- [hrsh7th/cmp-path](https://github.com/hrsh7th/cmp-path) - Path source for nvim-cmp
- [hrsh7th/cmp-cmdline](https://github.com/hrsh7th/cmp-cmdline) - Command line source for nvim-cmp
- [saadparwaiz1/cmp_luasnip](https://github.com/saadparwaiz1/cmp_luasnip) - Snippets source for nvim-cmp

### Snippets
- [L3MON4D3/LuaSnip](https://github.com/L3MON4D3/LuaSnip) - Snippet engine
- [rafamadriz/friendly-snippets](https://github.com/rafamadriz/friendly-snippets) - Collection of snippets

### AI Assistance
- [zbirenbaum/copilot.lua](https://github.com/zbirenbaum/copilot.lua) - GitHub Copilot integration
- [zbirenbaum/copilot-cmp](https://github.com/zbirenbaum/copilot-cmp) - Copilot source for nvim-cmp

### Code Parsing and Highlighting
- [nvim-treesitter/nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) - Syntax highlighting and code analysis
- [windwp/nvim-autopairs](https://github.com/windwp/nvim-autopairs) - Auto-close brackets, quotes, etc.
- [numToStr/Comment.nvim](https://github.com/numToStr/Comment.nvim) - Easy code commenting

### Git Integration
- [lewis6991/gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim) - Git signs in the gutter
- [sindrets/diffview.nvim](https://github.com/sindrets/diffview.nvim) - Git diff viewer

### Database Support 
- [kristijanhusak/vim-dadbod-ui](https://github.com/kristijanhusak/vim-dadbod-ui) - Simple UI for vim-dadbod
- [tpope/vim-dadbod](https://github.com/tpope/vim-dadbod) - Modern database interface for vim/nvim
- [tami5/sqlite.lua](https://github.com/kkharji/sqlite.lua) - For better support of sqlite
- [jsborjesson/vim-uppercase-sql](https://github.com/jsborjesson/vim-uppercase-sql) - Automatically uppercase SQL keywords

## Utility Plugins

- [nvim-lua/plenary.nvim](https://github.com/nvim-lua/plenary.nvim) - Lua functions library
- [kyazdani42/nvim-web-devicons](https://github.com/kyazdani42/nvim-web-devicons) - Icons for various plugins
- [norcalli/nvim-colorizer.lua](https://github.com/norcalli/nvim-colorizer.lua) - Color highlighter

## Installing Additional Plugins

To add a new plugin to your configuration:

1. Edit `~/.config/nvim/lua/plugins/init.lua` or create a new file in the `plugins` directory.

2. Add your plugin configuration following the lazy.nvim format:

```lua
return {
  "username/plugin-name",
  config = function()
    -- Plugin configuration here
  end,
  -- Other options as needed
}
```

3. Save the file and run `:Lazy sync` in Neovim to install the new plugin.

## Managing Plugins

Use these commands to manage your plugins:

- `:Lazy` - Open the plugin manager dashboard
- `:Lazy install` - Install missing plugins
- `:Lazy update` - Update plugins
- `:Lazy clean` - Remove unused plugins
- `:Lazy sync` - Update and clean plugins

[← Back to Home](index.html)
