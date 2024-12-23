return {
    {
        "williamboman/mason.nvim",
        config = true,
        lazy = true,
        cmd = "Mason"
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
        lazy = true,
        event = "LspAttach"
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            -- "hrsh7th/nvim-cmp",
            -- "hrsh7th/cmp-nvim-lsp",
            -- "hrsh7th/cmp-buffer",
            -- "hrsh7th/cmp-path",
            -- "hrsh7th/cmp-nvim-lua",
            -- "hrsh7th/cmp-cmdline",
            -- "onsails/lspkind.nvim",
            "SmiteshP/nvim-navic"
        },
        config = function()
            vim.lsp.inlay_hint.enable(true)
            -- require("lspkind").init()
            vim.lsp.set_log_level("TRACE")

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf, remap = false, silent = true }

                    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
                    vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
                    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
                    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)

                    vim.keymap.set('n', '<leader>ps', function() vim.diagnostic.open_float() end, opts)
                    vim.keymap.set('n', '<leader>pn', function() vim.diagnostic.goto_next() end, opts)
                    vim.keymap.set('n', '<leader>pp', function() vim.diagnostic.goto_prev() end, opts)
                    vim.keymap.set('n', '<leader>pq', function() vim.diagnostic.setqflist() end, opts)

                    vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format() end, opts)

                    local client = vim.lsp.get_client_by_id(event.data.client_id)

                    if client.name == "clangd" then
                        vim.keymap.set("n", "<C-O>", ":ClangdSwitchSourceHeader<CR>", opts)
                    end
                    if client.name == "ocamllsp" then
                        vim.keymap.set("n", "<C-O>", function()
                            vim.lsp.buf.code_action({
                                filter = function(x)
                                    return string.find(x.title, "Open .*%.ml") ~= nil
                                end,
                                apply = true
                            })
                        end, opts)
                        vim.keymap.set("n", "<C-p>", function()
                            if vim.bo.modified then
                                vim.notify "Save before trying to promote"
                                return
                            end

                            local fsevent = assert(vim.uv.new_fs_event())
                            local path = vim.fn.expand "%:p"
                            fsevent:start(path, {}, function(err, _)
                                fsevent:stop()
                                fsevent:close()

                                if err then
                                    print("Oh no, an error", vim.inspect(err))
                                    return
                                end
                                vim.defer_fn(vim.cmd.checktime, 100)
                            end)

                            vim.lsp.buf.code_action {
                                filter = function(x)
                                    return string.find(x.title, "Promote") ~= nil
                                end,
                                apply = true,
                            }
                        end, opts)
                    end

                    if client.server_capabilities.documentSymbolProvider then
                        require('nvim-navic').attach(client, event.buf)
                    end
                    --- Guard against servers without the signatureHelper capability
                    if client.server_capabilities.codeLensProvider then
                        vim.lsp.codelens.refresh()
                        vim.api.nvim_create_autocmd({ "InsertLeave", "CursorHold" }, {
                            desc = "Codelens refresh",
                            buffer = event.buf,
                            callback = function(_)
                                vim.lsp.codelens.refresh({ bufnr = event.buf })
                            end
                        })
                    end
                    if client.server_capabilities.documentFormattingProvider then
                        -- format on save autocmd
                        vim.api.nvim_create_autocmd({ "BufWritePre" },
                            {
                                desc = "LSP autoformat",
                                buffer = event.buf,
                                callback = function() vim.lsp.buf.format() end
                            })
                    end
                end
            })

            local lspconfig_defaults = require('lspconfig').util.default_config
            lspconfig_defaults.capabilities = vim.tbl_deep_extend(
                'force',
                lspconfig_defaults.capabilities,
                require('blink.cmp').get_lsp_capabilities()
            )

            require('lspconfig').ocamllsp.setup({
                settings = {
                    codelens = { enable = true },
                    inlayHints = { enable = true },
                    syntaxDocumentation = { enable = true },
                },
                filetypes = {
                    "ocaml",
                    "ocaml.interface",
                    "ocaml.menhir",
                    "ocaml.cram",
                    "ocaml.mlx",
                    "ocaml.ocamllex",
                    "reason",
                },
                get_language_id = function(_, ftype)
                    return ftype
                end,
            })

            require('mason-lspconfig').setup({
                ensure_installed = {},
                handlers = {
                    -- The first entry (without a key) will be the default handler
                    -- and will be called for each installed server that doesn't have
                    -- a dedicated handler.
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {}
                    end,
                    clangd = function()
                        require('lspconfig').clangd.setup {
                            cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=bundled", "--header-insertion=never", "--suggest-missing-includes", "--cross-file-rename", "--enable-config", "--limit-results=0", "--header-insertion-decorators", "-j=8", "--folding-ranges" },
                            settings = {
                                clangd = {
                                    InlayHints = {
                                        Enabled = true,
                                        ParameterNames = true,
                                        DeducedTypes = true,
                                        Designators = true,
                                    },
                                    fallbackFlags = { "-std=c++20" },
                                },
                            }
                        }
                    end,
                    rust_analyzer = function()
                        require('lspconfig').rust_analyzer.setup {
                            ["rust-analyzer"] = {
                                settings = {
                                    numThreads = 8,
                                    completion = {
                                        limit = 50,
                                        postfix = {
                                            enable = false
                                        },
                                    }
                                },
                                checkOnSave = {
                                    command = "clippy",
                                    extraArgs = {
                                        "--target-dir=target/analyzer"
                                    }
                                },
                            }
                        }
                    end,
                    basedpyright = function()
                        require("lspconfig").basedpyright.setup({
                            settings = {
                                basedpyright = {
                                    analysis = {
                                        typeCheckingMode = "basic",
                                        autoSearchPaths = true,
                                    },
                                },
                                python = {
                                    pythonPath = "venv\\Scripts\\python.exe"
                                }
                            }
                        })
                    end,
                    lua_ls = function()
                        require 'lspconfig'.lua_ls.setup {
                            on_init = function(client)
                                if client.workspace_folders then
                                    local path = client.workspace_folders[1].name
                                    if vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                                        return
                                    end
                                end

                                client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
                                    runtime = {
                                        -- Tell the language server which version of Lua you're using
                                        -- (most likely LuaJIT in the case of Neovim)
                                        version = 'LuaJIT'
                                    },
                                    -- Make the server aware of Neovim runtime files
                                    workspace = {
                                        checkThirdParty = false,
                                        library = {
                                            vim.env.VIMRUNTIME
                                        }
                                    }
                                })
                            end,
                            settings = {
                                Lua = {}
                            }
                        }
                    end
                },
            })
        end,
        lazy = true,
        event = "VeryLazy"
    }
}
