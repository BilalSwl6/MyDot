return {
    "ojroques/nvim-osc52",
    config = function()
        require('osc52').setup({
            max_length = 0,  -- Unlimited length for OSC52 messages
            silent = false,  -- Show a message when copying
            trim = false,    -- Don't trim trailing newlines before sending
        })

        -- Function to copy selected text to clipboard
        local function copy()
            require('osc52').copy_register('"')
        end

        -- Automatically copy to clipboard on yank (`y`)
        vim.api.nvim_create_autocmd('TextYankPost', {
            callback = function()
                if vim.v.event.operator == 'y' and vim.v.event.regname == '' then
                    copy()
                end
            end
        })

        -- Set OSC52 as the clipboard provider
        vim.g.clipboard = {
            name = "osc52",
            copy = {
                ["+"] = copy,  -- Copy to system clipboard (Ctrl+Shift+V to paste)
                ["*"] = copy,  -- Copy to primary selection (Linux)
            },
            paste = {
                ["+"] = function() return require('osc52').paste() end,
                ["*"] = function() return require('osc52').paste() end,
            }
        }
    end
}
