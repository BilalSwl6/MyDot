-- ~/.config/nvim/lua/plugins/framework.lua
return {
    -- PHP/Blade Support
    {
        'jwalton512/vim-blade',
        ft = {'blade', 'php'},
    },

    -- Treesitter with Manual Parser Installation
    {
        'nvim-treesitter/nvim-treesitter',
        build = function()
            require('nvim-treesitter.install').update({ with_sync = true })()
        end,
        config = function()
            local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
            
            -- Custom Blade parser configuration
            parser_config.blade = {
                install_info = {
                    url = "https://github.com/EmranMR/tree-sitter-blade",
                    files = {"src/parser.c"},
                    branch = "main",
                },
                filetype = "blade",
            }

            require('nvim-treesitter.configs').setup {
                -- Ensure installation of parsers
                ensure_installed = {
                    -- Web and Frontend
                    'html',
                    'css',
                    'javascript',
                    'typescript',
                    'tsx',
                    'vue',

                    -- Backend
                    'php',
                    'python',
                    'vim',
                    'vimdoc',

                    -- Templating
                    'blade',
                    'htmldjango',
                },
                
                -- Enable syntax highlighting
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                
                -- Enable indentation
                indent = {
                    enable = true,
                },
            }
        end
    },

    -- Updated LSP Configuration
    {
        'neovim/nvim-lspconfig',
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
        },
        config = function()
            local lspconfig = require('lspconfig')
            
            -- Use ts_ls instead of tsserver
            lspconfig.tsserver.setup = nil  -- Deprecated
            lspconfig.ts_ls.setup {
                settings = {
                    typescript = {
                        format = {
                            enable = true,
                        },
                    },
                },
            }

            -- Laravel PHP Language Server
            lspconfig.intelephense.setup {
                settings = {
                    intelephense = {
                        diagnostics = {
                            enable = true,
                        },
                        environment = {
                            phpVersion = "8.2",
                        },
                        stubs = {
                            "apache", "bcmath", "bz2", "calendar", 
                            "com_dotnet", "Core", "ctype", "curl", 
                            "date", "dba", "dom", "enchant", 
                            "exif", "FFI", "fileinfo", "filter", 
                            "fpm", "ftp", "gd", "gettext", "gmp", 
                            "hash", "iconv", "imap", "intl", "json", 
                            "ldap", "libxml", "mbstring", "mysqli", 
                            "oci8", "openssl", "pcntl", "pcre", 
                            "PDO", "pdo_mysql", "Phar", "posix", 
                            "pspell", "readline", "Reflection", 
                            "session", "shmop", "SimpleXML", 
                            "snmp", "soap", "sockets", "sodium", 
                            "SPL", "sqlite3", "standard", 
                            "superglobals", "sysvmsg", "sysvsem", 
                            "sysvshm", "tidy", "tokenizer", "xml", 
                            "xmlreader", "xmlrpc", "xmlwriter", "xsl", 
                            "Zend OPcache", "zip", "zlib"
                        }
                    }
                }
            }

            -- Django/Python Language Server
            lspconfig.pyright.setup {
                settings = {
                    python = {
                        analysis = {
                            typeCheckingMode = 'basic',
                            diagnosticSeverityOverrides = {
                                reportUnknownMemberType = 'none',
                                reportUnknownArgumentType = 'none'
                            }
                        }
                    }
                }
            }
        end
    }
}
