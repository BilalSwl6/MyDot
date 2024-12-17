return {
	"nvim-telescope/telescope.nvim",
		config = function()
			require("telescope").setup({
				defaults = {
					file_ignore_patterns = { "%.git/", "node_modules/", "%.cache/" },
					prompt_prefix = "❯ ",
					selection_caret = "❯ ",
					layout_config = {
						prompt_position = "top",
					},
					mappings = {
						i = {
							["<esc>"] = require("telescope.actions").close,
						},
					},
				},
			})
		end,
}
