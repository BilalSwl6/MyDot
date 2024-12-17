return {
	"akinsho/horizon.nvim",
	lazy = false,
	version = "*",
	priority = 1000,
	opts = {
		overrides = {
			colors = {
				CursorLine = { bg = '#1e1e1e', fg = '#ffffff', underline = true }
			}
		},
		config = function()
			vim.cmd("colorscheme horizon")
			vim.g.horizon_style = "dark"
		end,
	}
}
