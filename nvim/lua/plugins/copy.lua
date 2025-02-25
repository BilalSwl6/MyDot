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
        
        -- Custom notification function (to only show "Copy successful")
        local original_notify = vim.notify
        vim.notify = function(msg, level, opts)
            if msg:match("Copied") then
                original_notify("Copy successful", level, opts)
            else
                original_notify(msg, level, opts)
            end
        end

        
        -- This minimal clipboard setup only handles copy
        vim.api.nvim_set_option("clipboard", "")
    end
}
