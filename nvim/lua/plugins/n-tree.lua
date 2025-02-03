return {                                                          "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons", -- Icons for better UI
  },
  config = function()
    require("nvim-tree").setup {
      git = {
        enable = true,        -- Enable Git integration
        timeout = 1000,       -- Git command timeout
        ignore = false,       -- Show files even if ignored by .gitignore
      },
      filters = {
        dotfiles = false,     -- Show dotfiles like .env
        git_ignored = false,  -- Show .gitignore files
        custom = {},          -- No additional hidden files
      },
      renderer = {
        icons = {
          show = {
            git = true,
            folder = true,
            file = true,
            folder_arrow = true,
          },
        },
        group_empty = true,   -- Group empty directories
      },
      actions = {
        open_file = {
          quit_on_open = true, -- Set to true if you want nvim-tree to close after opening a file
          resize_window = true, -- Resize window when opening files
        },
      },
      view = {
        width = 30,           -- Default tree width
        side = "left",        -- Place the tree on the left
        adaptive_size = true, -- Auto-resize based on content
      },
    }
  end,
}
