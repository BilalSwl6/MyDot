return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    options = {
        theme = 'horizon',  -- Set the theme to 'gruvbox'
        section_separators = { '', '' },  -- Define the section separators
    },
    config = function()
        require('lualine').setup()  -- Set up lualine with the provided configuration
    end,
}
