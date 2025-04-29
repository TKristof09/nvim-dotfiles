local autoformat_disabled = {
    "ocaml.cram",
    "ocaml.menhir",
    "ocaml.ocamllex",
}

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
            "SmiteshP/nvim-navic"
        },
        config = function()
            vim.lsp.inlay_hint.enable(true)
            -- vim.lsp.set_log_level("TRACE")

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local function get_opts(overrides)
                        local opts = { buffer = event.buf, remap = false, silent = true }
                        local overrides = overrides or {}
                        return vim.tbl_extend("force", opts, overrides)
                    end

                    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end,
                        get_opts({ desc = "LSP: Go to definition" }))
                    vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end,
                        get_opts({ desc = "LSP: Go to type definition" }))
                    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end,
                        get_opts({ desc = "LSP: Hover documentation" }))
                    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end,
                        get_opts({ desc = "LSP: Rename symbol" }))
                    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end,
                        get_opts({ desc = "LSP: Show signature help" }))
                    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end,
                        get_opts({ desc = "LSP: Code actions" }))

                    vim.keymap.set('n', '<leader>ps', function() vim.diagnostic.open_float() end,
                        get_opts({ desc = "LSP: Show diagnostics" }))
                    vim.keymap.set('n', '<leader>pn', function() vim.diagnostic.goto_next() end,
                        get_opts({ desc = "LSP: Next diagnostic" }))
                    vim.keymap.set('n', '<leader>pp', function() vim.diagnostic.goto_prev() end,
                        get_opts({ desc = "LSP: Previous diagnostic" }))
                    vim.keymap.set('n', '<leader>pq', function() vim.diagnostic.setqflist() end,
                        get_opts({ desc = "LSP: Send diagnostics to quickfix" }))

                    vim.keymap.set('n', '<leader>lf', function() vim.lsp.buf.format() end,
                        get_opts({ desc = "LSP: Format buffer" }))

                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client == nil then return end

                    if client.name == "clangd" then
                        vim.keymap.set("n", "<C-O>", ":ClangdSwitchSourceHeader<CR>",
                            get_opts({ desc = "LSP: Open header" }))
                    end
                    if client.name == "ocamllsp" then
                        vim.keymap.set("n", "<C-O>", function()
                            vim.lsp.buf.code_action({
                                filter = function(x)
                                    return string.find(x.title, "Open .*%.ml") ~= nil
                                end,
                                apply = true
                            })
                        end, get_opts({ desc = "LSP: Open header" }))
                        vim.keymap.set("n", "<C-p>", function()
                            -- if vim.bo.modified then
                            --     vim.notify "Save before trying to promote"
                            --     return
                            -- end
                            --
                            -- local fsevent = assert(vim.uv.new_fs_event())
                            -- local path = vim.fn.expand "%:p"
                            -- fsevent:start(path, {}, function(err, _)
                            --     fsevent:stop()
                            --     fsevent:close()
                            --
                            --     if err then
                            --         print("Oh no, an error", vim.inspect(err))
                            --         return
                            --     end
                            --     vim.defer_fn(vim.cmd.checktime, 100)
                            -- end)
                            --
                            -- vim.lsp.buf.code_action {
                            --     filter = function(x)
                            --         return string.find(x.title, "Promote") ~= nil
                            --     end,
                            --     apply = true,
                            -- }
                            vim.cmd("silent! !dune promote %:.")
                        end, get_opts({ desc = "LSP: Promote file" }))
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
                                callback = function()
                                    local ft = vim.filetype.match({ buf = event.buf })
                                    if not vim.tbl_contains(autoformat_disabled, ft) and not vim.b.disable_autoformat and not vim.g.disable_autoformat then
                                        vim.lsp.buf.format()
                                    end
                                end
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
                    "ocaml_interface",
                    "ocaml.cram",
                    "ocaml.mlx",
                    "ocaml.menhir",
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
                                        autoSearchPaths = true,
                                        useLibraryCodeForTypes = true,
                                    },
                                },
                            },
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
