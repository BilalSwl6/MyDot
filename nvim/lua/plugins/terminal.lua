return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			size = 20, -- Terminal size for horizontal/vertical splits
			open_mapping = [[<C-t>]], -- Keybinding to open the terminal
			hide_numbers = true, -- Hide line numbers in terminal buffer
			shade_filetypes = {}, -- Filetypes to shade
			shade_terminals = true, -- Enable shading for terminals
			shading_factor = 2, -- Darkening factor for terminal background
			start_in_insert = true, -- Start terminal in insert mode
			insert_mappings = true, -- Apply terminal keybindings in insert mode
			persist_size = true, -- Preserve terminal size across toggles
			direction = "horizontal", -- Terminal direction: 'horizontal', 'vertical', 'float', or 'tab'
			close_on_exit = true, -- Close terminal when the process exits
			shell = vim.o.shell, -- Use the default shell
			float_opts = {
				border = "single", -- Border style: 'single', 'double', 'curved', etc.
				width = 100, -- Width of the floating terminal
				height = 30, -- Height of the floating terminal
				winblend = 3, -- Transparency of the floating terminal
				highlights = {
					border = "Normal", -- Highlight for the border
					background = "Normal", -- Highlight for the background
				},
			},
		})
	end,
}
