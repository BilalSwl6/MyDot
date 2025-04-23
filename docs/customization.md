# Customization Guide

MyDot Neovim configuration is designed to be easily customizable. This guide will help you tailor the configuration to your specific needs.

## Configuration Structure

The configuration is organized in a modular structure:

```
~/.config/nvim/
├── init.lua              # Main entry point
├── lua/
│   ├── config/             # Core configuration
│   │   ├── keymappings.lua   # Key mappings
│   │   ├── lazy.lua   # Neovim options
│   │   └── ...
│   └── plugins/          # Plugin configurations
│       ├── lsp.lua       # LSP setup
│       ├── telescope.lua # Telescope setup
│       └── ...
└── ...
```

## Customizing Options

To change Neovim's built-in options, edit `~/.config/nvim/lua/config/options.lua`. This file contains settings like:

```lua
-- Example: Changing basic editor settings
vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = true  -- Show relative line numbers
vim.opt.tabstop = 2            -- Tab width
vim.opt.shiftwidth = 2         -- Indentation width
```

## Customizing Keymappings

To modify key mappings, edit `~/.config/nvim/lua/core/keymappings.lua`. The file is organized by functionality:

```lua
-- Example: Adding a custom keymapping
vim.keymap.set("n", "<leader>w", ":w<CR>", { desc = "Save file" })
```

## Customizing Colorscheme

MyDot uses the VSCode theme by default. To switch themes:

1. First, add your preferred colorscheme plugin to `~/.config/nvim/lua/plugins/<theme>.lua`:

```lua
-- Example: Adding the Catppuccin theme
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      -- your configuration options
    })
  end
}
```

2. Then, set it as the default in `~/.config/nvim/lua/core/options.lua`:

```lua
-- Set colorscheme
vim.cmd.colorscheme "catppuccin"
```

## Customizing LSP Settings

To customize the Language Server Protocol settings:

1. Edit `~/.config/nvim/lua/plugins/lsp.lua` to modify LSP server configurations:

```lua
-- Example: Customizing Python LSP settings
require("lspconfig").pyright.setup {
  settings = {
    python = {
      analysis = {
        typeCheckingMode = "basic",
        autoSearchPaths = true,
        useLibraryCodeForTypes = true
      }
    }
  }
}
```

2. Add new language servers through Mason:

```lua
-- In your LSP configuration file
require("mason-lspconfig").setup {
  ensure_installed = { 
    "lua_ls",
    "pyright",
    "tsserver",
    "rust_analyzer",
    -- Add other servers here
  },
}
```

<!-- ## Adding Custom Snippets -->
<!---->
<!-- To add your own snippets: -->
<!---->
<!-- 1. Create a snippets directory: -->
<!---->
<!-- ```bash -->
<!-- mkdir -p ~/.config/nvim/snippets -->
<!-- ``` -->
<!---->
<!-- 2. Create snippet files for specific languages (e.g., `~/.config/nvim/snippets/lua.json`) -->
<!---->
<!-- 3. Load your snippets in the LuaSnip configuration: -->
<!---->
<!-- ```lua -->
<!-- -- In your snippets configuration file -->
<!-- require("luasnip.loaders.from_vscode").load({ -->
<!--   paths = { "~/.config/nvim/snippets" } -->
<!-- }) -->
<!-- ``` -->

## Creating Custom Plugins

For more complex customizations, you can create your own plugins:

1. Create a new file in the plugins directory, e.g., `~/.config/nvim/lua/plugins/<custom>.lua`

2. Define your plugin:

```lua
-- Example of a simple custom plugin
return {
  "MyPlugin",
  config = function()
    -- Your custom functionality here
    vim.api.nvim_create_user_command("MyCommand", function()
      print("Hello from my custom plugin!")
    end, {})
  end
}
```

## Overriding Default Configurations

To override default plugin configurations:

1. Find the plugin you want to customize in `~/.config/nvim/lua/plugins/`

2. Modify the existing configuration or create a new file with your settings

```lua
-- Example: Customizing Telescope
return {
  "nvim-telescope/telescope.nvim",
  config = function()
    require('telescope').setup {
      defaults = {
        layout_strategy = 'vertical',
        layout_config = { height = 0.95, width = 0.95 },
        -- Your custom settings here
      }
    }
  end
}
```

## Creating Custom Commands

To create custom commands:

```lua
-- In any Lua file loaded by your configuration
vim.api.nvim_create_user_command("FormatBuffer", function()
  vim.lsp.buf.format({ async = true })
end, {})
```

## Using Local Configuration

For machine-specific settings that you don't want to commit to version control:

1. Create a local configuration file:

```bash
touch ~/.config/nvim/lua/local.lua
```

2. Load this file in your `init.lua`:

```lua
-- At the end of init.lua
pcall(require, "local") -- Load local configuration if it exists
```

[← Back to Home](index.html)
