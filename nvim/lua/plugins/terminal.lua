return {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
        require("toggleterm").setup({
            size = 20,
            open_mapping = [[<C-t>]], -- This is already set for Control + t
            hide_numbers = true,
            shade_filetypes = {},
            shade_terminals = true,
            shading_factor = 2,
            start_in_insert = true,
            insert_mappings = true,
            persist_size = true,
            direction = "horizontal",
            close_on_exit = true,
            shell = "/bin/zsh", -- Set zsh as default shell
            float_opts = {
                border = "single",
                width = 100,
                height = 30,
                winblend = 15, -- Increased transparency (0-100, where 100 is fully transparent)
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
            },
            -- Add background transparency for non-floating terminals
            highlights = {
                Normal = {
                    guibg = "NONE", -- This makes the background transparent
                    ctermbg = "NONE"
                },
            },
        })
    end,
}
