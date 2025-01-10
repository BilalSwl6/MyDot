return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {
	git = {
		enable = true,
		timeout = 1000,
	},
      actions = {
        open_file = {
          quit_on_open = true, -- Automatically close nvim-tree when opening a file
        },
      },
    }
  end,
}
