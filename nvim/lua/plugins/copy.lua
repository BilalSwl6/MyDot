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

        -- Function to handle paste (overrides default p behavior)
        local function smart_paste()
            local osc52_paste = require('osc52').paste()
            if osc52_paste and osc52_paste ~= "" then
                -- Use OSC52 paste content if available
                vim.api.nvim_put({osc52_paste}, 'c', true, true)
                vim.notify("Pasted from OSC52 clipboard", vim.log.levels.INFO)
            else
                -- Fall back to regular paste if OSC52 clipboard is empty
                local keys = vim.api.nvim_replace_termcodes('p', true, false, true)
                vim.api.nvim_feedkeys(keys, 'n', false)
            end
        end

        -- Set up keymapping for paste
        vim.keymap.set({'n', 'v'}, 'p', smart_paste, {noremap = true, silent = true})

        -- Custom notification function (to only show "Copy successful")
        local original_notify = vim.notify
        vim.notify = function(msg, level, opts)
            if msg:match("Copied") then
                original_notify("Copy successful", level, opts)
            else
                original_notify(msg, level, opts)
            end
        end

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
