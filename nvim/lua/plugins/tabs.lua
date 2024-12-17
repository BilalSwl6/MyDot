return {
    -- Tab line
    "crispgm/nvim-tabline",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- For file icons
    },
    config = function()
        require("tabline").setup {
            show_index = true, -- Show tab index (e.g., 1, 2, 3)
            show_modify = true, -- Show modification indicator
            no_name = "Unnamed", -- Name to display for unnamed buffers
        }
        vim.o.showtabline = 2 -- Always show tabline
    end,
}
