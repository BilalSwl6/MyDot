return {
    {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    },
    {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'neovim/nvim-lspconfig'
        },
        config = function()
            require('mason-lspconfig').setup({
                ensure_installed = {
                    'pyright',       -- Python
                    'html',          -- HTML
                    'cssls',         -- CSS
                    'tailwindcss',   -- Tailwind
                    'eslint',        -- ESLint
                    'jsonls',        -- JSON
                    'volar',         -- Vue
                    'ts_ls',         -- TypeScript/JavaScript
                }
            })
        end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',           -- LSP completion source
            'hrsh7th/cmp-buffer',             -- Buffer completion source
            'hrsh7th/cmp-path',               -- Path completion source
            'hrsh7th/cmp-cmdline',            -- Cmdline completion source
            'L3MON4D3/LuaSnip',              -- Snippet engine
            'saadparwaiz1/cmp_luasnip',       -- Snippet completion source
            'rafamadriz/friendly-snippets',    -- Snippet collection
            'zbirenbaum/copilot-cmp',         -- Copilot completion source
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            
            -- Load friendly-snippets
            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ 
                        select = true,
                        behavior = cmp.ConfirmBehavior.Replace  -- This helps with auto-import
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
                    { name = 'copilot', group_index = 2 },  -- Add Copilot source
                    { name = 'nvim_lsp', group_index = 2 },
                    { name = 'luasnip', group_index = 2 },
                }, {
                    { name = 'buffer', group_index = 3 },
                    { name = 'path', group_index = 3 },
                }),
                sorting = {
                    priority_weight = 2,
                    comparators = {
                        require('copilot_cmp.comparators').prioritize,
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        cmp.config.compare.locality,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                }
            })

            -- Set up completion for / search
            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' }
                }
            })

            -- Set up completion for : commands
            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = 'path' }
                }, {
                    { name = 'cmdline' }
                })
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        config = function()
            local lspconfig = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Global LSP keybindings
            vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
            vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

            -- Use LspAttach autocommand to only map the following keys
            -- after the language server attaches to the current buffer
            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api.nvim_create_augroup('UserLspConfig', {}),
                callback = function(ev)
                    local opts = { buffer = ev.buf }
                    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { buffer = ev.buf, desc = 'Go to declaration' })
                    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = ev.buf, desc = 'Go to definition' })
                    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = ev.buf, desc = 'Hover Documentation' })
                    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { buffer = ev.buf, desc = 'Go to implementation' })
                    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { buffer = ev.buf, desc = 'Signature Documentation' })
                    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { buffer = ev.buf, desc = 'Add workspace folder' })
                    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { buffer = ev.buf, desc = 'Remove workspace folder' })
                    vim.keymap.set('n', '<leader>wl', function()
                        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, { buffer = ev.buf, desc = 'List workspace folders' })
                    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { buffer = ev.buf, desc = 'Type Definition' })
                    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = ev.buf, desc = 'Rename' })
                    vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { buffer = ev.buf, desc = 'Code Action' })
                    vim.keymap.set('n', 'gr', vim.lsp.buf.references, { buffer = ev.buf, desc = 'Go to references' })
                    vim.keymap.set('n', '<leader>f', function()
                        vim.lsp.buf.format { async = true }
                    end, { buffer = ev.buf, desc = 'Format file' })
                end,
            })

            -- TypeScript/React setup with tsserver
            lspconfig.tsserver.setup {
                capabilities = capabilities,
                settings = {
                    typescript = {
                        format = {
                            enable = true
                        },
                        suggest = {
                            autoImports = true,
                            completeFunctionCalls = true,
                        },
                        inlayHints = {
                            enable = true
                        }
                    },
                    javascript = {
                        format = {
                            enable = true
                        },
                        suggest = {
                            autoImports = true,
                            completeFunctionCalls = true,
                        },
                        inlayHints = {
                            enable = true
                        }
                    }
                }
            }

            -- Python setup with auto-imports
            lspconfig.pyright.setup {
                capabilities = capabilities,
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = 'basic',
                            autoImportCompletions = true,
                            autoSearchPaths = true,
                            useLibraryCodeForTypes = true,
                            diagnosticMode = "workspace",
                        }
                    }
                }
            }

            -- PHP/Laravel setup
            lspconfig.intelephense.setup {
                capabilities = capabilities,
                settings = {
                    intelephense = {
                        diagnostics = {
                            enable = true,
                            run = "onType",
                        },
                        environment = {
                            phpVersion = "8.2"
                        },
                        files = {
                            maxSize = 5000000,
                        },
                        completion = {
                            insertUseDeclaration = true,    -- Auto-import
                            fullyQualifyGlobalConstantsAndFunctions = true,
                            triggerParameterHints = true,
                            maxItems = 100,
                        },
                        format = {
                            enable = true
                        },
                        references = {
                            exclude = {}
                        }
                    }
                }
            }

            -- Lua setup
            lspconfig.lua_ls.setup {
                capabilities = capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        },
                        workspace = {
                            checkThirdParty = false,
                        },
                        completion = {
                            callSnippet = "Replace"
                        }
                    }
                }
            }
        end
    },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        dependencies = {
            "zbirenbaum/copilot-cmp",
        },
        config = function()
            require("copilot").setup({
                suggestion = {
                    enabled = false,  -- Disable native suggestion as we use cmp
                    auto_trigger = false,
                },
                panel = {
                    enabled = false,  -- Disable native panel as we use cmp
                },
                filetypes = {
                    yaml = false,
                    markdown = false,
                    help = false,
                    gitcommit = false,
                    gitrebase = false,
                    hgcommit = false,
                    svn = false,
                    cvs = false,
                    ["."] = false,
                }
            })
        end
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = {
            "zbirenbaum/copilot.lua",
        },
        config = function()
            require("copilot_cmp").setup({
                formatters = {
                    label = require("copilot_cmp.format").format_label_text,
                    insert_text = require("copilot_cmp.format").format_insert_text,
                    preview = require("copilot_cmp.format").deindent,
                },
                event = { "InsertEnter", "LspAttach" },
                fix_pairs = true,
            })
        end
    }
}
