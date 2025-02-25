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

        -- Set up external clipboard commands (using xclip, pbpaste, etc. depending on system)
        local paste_cmd
        if vim.fn.has('mac') == 1 then
            paste_cmd = 'pbpaste'
        elseif vim.fn.has('wsl') == 1 then
            paste_cmd = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))'
        elseif vim.fn.executable('xclip') == 1 then
            paste_cmd = 'xclip -selection clipboard -o'
        elseif vim.fn.executable('wl-paste') == 1 then
            paste_cmd = 'wl-paste'
        end

        -- Function for handling paste with external clipboard command
        local function external_paste()
            if paste_cmd then
                local clipboard_content = vim.fn.system(paste_cmd)
                if clipboard_content and #clipboard_content > 0 then
                    -- Split by lines and remove possible trailing newline
                    local lines = {}
                    for line in string.gmatch(clipboard_content, "[^\r\n]+") do
                        table.insert(lines, line)
                    end
                    vim.api.nvim_put(lines, 'c', true, true)
                    vim.notify("Paste successful", vim.log.levels.INFO)
                    return true
                end
            end
            return false
        end

        -- Set up keymapping for paste
        vim.keymap.set({'n', 'v'}, 'p', function()
            -- Try external paste first
            if not external_paste() then
                -- Fall back to regular paste if external paste fails
                local keys = vim.api.nvim_replace_termcodes('p', true, false, true)
                vim.api.nvim_feedkeys(keys, 'n', false)
            end
        end, {noremap = true, silent = true})

        -- Set OSC52 as the clipboard provider for copying only
        vim.g.clipboard = {
            name = "osc52",
            copy = {
                ["+"] = copy,  -- Copy to system clipboard (Ctrl+Shift+V to paste)
                ["*"] = copy,  -- Copy to primary selection (Linux)
            },
            paste = {
                ["+"] = function() return "" end,  -- Let our custom paste function handle this
                ["*"] = function() return "" end,  -- Let our custom paste function handle this
            }
        }
    end
}
