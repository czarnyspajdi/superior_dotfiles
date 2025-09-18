return {
    'neovim/nvim-lspconfig',
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
        "numToStr/Comment.nvim",
        "lukas-reineke/indent-blankline.nvim",
        "kylechui/nvim-surround",
        'm4xshen/autoclose.nvim',
        "gbprod/phpactor.nvim",
        "RRethy/vim-illuminate",
    },
    config = function()
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )


        vim.diagnostic.config({
            virtual_text = {
                prefix = "●", -- możesz zmienić na "▎", "x", "" itd.
                spacing = 2, -- odstęp od kodu
                source = "if_many", -- pokaż źródło błędu (np. rust-analyzer)
            },
            signs = true, -- znaki w kolumnie po lewej
            underline = true, -- podkreślenie błędnych fragmentów
            update_in_insert = false, -- nie aktualizuj w trybie insert
        })


        vim.keymap.set('n', '<leader>ci', function()
            vim.diagnostic.open_float(nil, {
                focus = true,
                scope = "cursor",
                border = "rounded",
                source = "always",
            })
        end, { desc = "Pokaż diagnostykę LSP w popupie" })

        require("fidget").setup({})
        require("mason").setup()

        require('mason-lspconfig').setup({
            ensure_installed = {
                "lua_ls",
                "emmet_language_server",
                "marksman",
                "rust-analyzer"
            },
            handlers = { -- config lsp
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                    })
                end,
                lua_ls = function()
                    require('lspconfig').lua_ls.setup({
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = 'LuaJIT'
                                },
                                diagnostics = {
                                    globals = { 'vim', 'love' },
                                },
                                workspace = {
                                    library = {
                                        vim.env.VIMRUNTIME,
                                    }
                                }
                            }
                        }
                    })
                end,

                rust_analyzer = function()
                    require('lspconfig').rust_analyzer.setup({
                        settings = {
                            ["rust-analyzer"] = {
                                diagnostics = {
                                    enable = true
                                }
                            }
                        }
                    })
                end,

            }

        })

        local cmp = require("cmp")
        local cmp_select = { behavior = cmp.SelectBehavior.Select }

        require("luasnip.loaders.from_vscode").lazy_load()

        cmp.setup({
            sources = {
                { name = 'path' },
                { name = "nvim_lsp" },
                { name = "luasnip", keyword_lenght = 2 },
                { name = "buffer",  keyword_lenght = 3 },
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
            }),
            snippets = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            formatting = {
                fields = { 'menu', 'abbr', 'kind' },

                format = function(entry, item)
                    local menu_icon = {
                        nvim_lsp = 'λ',
                        luasnip = '⋗',
                        buffer = 'Ω',
                        path = '🖫',
                        nvim_lua = 'Π',
                    }

                    item.menu = menu_icon[entry.source.name]
                    return item
                end,
            }
        })

        -- autoformat --
        local buffer_autoformat = function(bufnr)
            local group = 'lsp_autoformat'
            vim.api.nvim_create_augroup(group, { clear = false })
            vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })

            vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = bufnr,
                group = group,
                desc = "LSP format on save",
                callback = function()
                    vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                end
            })
        end

        vim.api.nvim_create_autocmd('LspAttach', {
            callback = function(event)
                local id = vim.tbl_get(event, 'data', 'client_id')
                local client = id and vim.lsp.get_client_by_id(id)

                if client == nil then
                    return
                end

                if client.supports_method('textDocument/formatting') then
                    buffer_autoformat(event.buf)
                end
            end
        })

        require("Comment").setup({
            mappings = {
                basic = true
            },
            opleader = {
                line = '<leader>cl',
                block = '<leader>cb',
            }
        })

        require("ibl").setup()

        require("nvim-surround").setup()
        require("autoclose").setup()
    end
}
