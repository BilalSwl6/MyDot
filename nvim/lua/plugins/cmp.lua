return {
    -- Copilot with advanced integration
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                panel = {
                    enabled = true,
                    auto_refresh = true,
                    keymap = {
                        jump_prev = "[[",
                        jump_next = "]]",
                        accept = "<CR>",
                        refresh = "gr",
                        open = "<M-CR>"
                    },
                    layout = {
                        position = "bottom",
                        ratio = 0.4
                    },
                },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<M-l>",
                        accept_word = "<M-w>",
                        accept_line = "<M-j>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>"
                    },
                },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    ["."] = false,
                    html = true,
                    css = true,
                    scss = true,
                    javascript = true,
                    typescript = true,
                    python = true,
                    lua = true,
                    php = true,
                    blade = true,
                    vue = true,
                    tailwindcss = true
                },
                copilot_node_command = 'node', -- Node.js version must be > 16.x
                server_opts_overrides = {}
            })
        end
    },

    -- Enhanced completion with Copilot integration
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'zbirenbaum/copilot-cmp',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind.nvim'  -- VSCode-like pictograms for completion
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            local lspkind = require('lspkind')
            require('copilot_cmp').setup()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ 
                        select = true,
                        behavior = cmp.ConfirmBehavior.Replace 
                    }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = cmp.config.sources({
                    { name = 'copilot', group_index = 2 },
                    { name = 'nvim_lsp', group_index = 2 },
                    { name = 'luasnip', group_index = 2 },
                    { name = 'buffer', group_index = 2 },
                    { name = 'path', group_index = 2 }
                }),
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                        maxwidth = 50,
                        ellipsis_char = '...',
                        before = function(entry, vim_item)
                            vim_item.menu = ({
                                copilot = "[Copilot]",
                                nvim_lsp = "[LSP]",
                                luasnip = "[Snippet]",
                                buffer = "[Buffer]",
                                path = "[Path]"
                            })[entry.source.name]
                            return vim_item
                        end
                    })
                },
                experimental = {
                    ghost_text = {
                        hl_group = 'Comment'
                    }
                }
            })

            -- Configure specific language snippets
            require('luasnip.loaders.from_vscode').lazy_load()
            
            -- Add custom snippets for specific languages
            require('luasnip.loaders.from_lua').load({
                paths = vim.fn.stdpath('config') .. '/snippets'
            })
        end
    },

    -- Language-specific snippet collections
    {
        'rafamadriz/friendly-snippets',
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load({
                exclude = { 'html', 'css', 'javascript', 'typescript', 'python' }
            })
        end
    }
}
