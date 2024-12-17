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
                    -- 'intelephense',  -- PHP
                    'pyright',       -- Python
                    -- 'lua_ls',        -- Lua
                    'html',          -- HTML
                    'cssls',         -- CSS
                    'tailwindcss',   -- Tailwind
                    'eslint',        -- ESLint
                    'jsonls',        -- JSON
                    'volar',         -- Vue
                }
            })
        end
    },
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason-lspconfig.nvim'
        },
        config = function()
            local lspconfig = require('lspconfig')
            
            -- TypeScript setup using ts_ls
            lspconfig.ts_ls.setup {
                settings = {
                    typescript = {
                        format = {
                            enable = true
                        },
                        suggest = {
                            autoImports = true
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
                            autoImports = true
                        },
                        inlayHints = {
                            enable = true
                        }
                    }
                }
            }

            -- Other language server configurations
            lspconfig.intelephense.setup {
                settings = {
                    intelephense = {
                        diagnostics = {
                            enable = true
                        },
                        environment = {
                            phpVersion = "8.2"
                        }
                    }
                }
            }

            lspconfig.pyright.setup {
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = 'basic'
                        }
                    }
                }
            }

            lspconfig.lua_ls.setup {
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            }
        end
    }
}
