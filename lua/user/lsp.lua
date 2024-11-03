require("mason").setup()

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf, remap = false, silent = true}

        vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
        vim.keymap.set("n", "gt", function() vim.lsp.buf.type_definition() end, opts)
        vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
        vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<C-O>", ":ClangdSwitchSourceHeader<CR>", opts)
        vim.keymap.set('n', '<leader>ps', function () vim.diagnostic.open_float() end, opts)
        vim.keymap.set('n', '<leader>pn', function () vim.diagnostic.goto_next() end, opts)
        vim.keymap.set('n', '<leader>pp', function () vim.diagnostic.goto_prev() end, opts)
        vim.keymap.set('n', '<leader>lf', function () vim.lsp.buf.format() end, opts)

        local client = vim.lsp.get_client_by_id(event.data.client_id)
        if client.server_capabilities.documentSymbolProvider then
            require('nvim-navic').attach(client, event.buf)
        end
        --- Guard against servers without the signatureHelper capability
        if client.server_capabilities.codeLensProvider then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd("InsertLeave", {
            desc = "Codelens refresh",
            buffer = event.buf,
            callback = function (_)
                vim.lsp.codelens.refresh({bufnr = event.buf})
            end
            })
        end

    end
})

local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
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
vim.lsp.set_log_level("TRACE")

require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        -- The first entry (without a key) will be the default handler
        -- and will be called for each installed server that doesn't have
        -- a dedicated handler.
        function (server_name) -- default handler (optional)
            require("lspconfig")[server_name].setup {}
        end,
        clangd = function()
            require('lspconfig').clangd.setup{
                cmd={"clangd", "--background-index", "--clang-tidy", "--completion-style=bundled", "--header-insertion=never", "--suggest-missing-includes", "--cross-file-rename", "--enable-config", "--limit-results=0", "--header-insertion-decorators", "-j=8", "--folding-ranges"},
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
            require('lspconfig').rust_analyzer.setup{
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
            require'lspconfig'.lua_ls.setup {
                on_init = function(client)
                    if client.workspace_folders then
                        local path = client.workspace_folders[1].name
                        if vim.uv.fs_stat(path..'/.luarc.json') or vim.uv.fs_stat(path..'/.luarc.jsonc') then
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





vim.lsp.inlay_hint.enable(true)


local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-l>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-d>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-w>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    ["<C-n>"] = cmp.mapping.complete(),
    ['<C-x>'] = cmp.mapping.scroll_docs(4),
    ['<C-m>'] = cmp.mapping.scroll_docs(-4),
    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp.mapping(function(fallback)
        if vim.snippet.active({direction = 1}) then
            vim.snippet.jump(1)
        else
            fallback()
        end
    end, {'i', 's'}),
    ['<C-b>'] = cmp.mapping(function(fallback)
        if vim.snippet.active({direction = -1}) then
            vim.snippet.jump(-1)
        else
            fallback()
        end
    end, {'i', 's'})
})
-- for some reason normal mappings don't work in cmdline
local cmp_cmdline_mappings =cmp.mapping.preset.cmdline({
    ['<C-l>'] = {
        c = function()
            local cmp = require('cmp')
            if cmp.visible() then
                cmp.select_prev_item()
            else
                cmp.complete()
            end
        end,
    },
    ['<C-d>'] = {
        c = function()
            local cmp = require('cmp')
            if cmp.visible() then
                cmp.select_next_item()
            else
                cmp.complete()
            end
        end,
    },
    ['<C-w>'] = {
        c = function()
            local cmp = require('cmp')
            if cmp.visible() then
                cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
            else
                cmp.complete()
            end
        end,
    },
})

local lspkind = require('lspkind')
cmp.setup({
    window = {
        completion = cmp.config.window.bordered({
            border = 'rounded',
            winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenu,CursorLine:CmpSelect,Search:None',
        }),
    },
    formatting = {
        fields = { "abbr", "kind", "menu" },
        format = lspkind.cmp_format({
            mode = 'symbol_text',
            maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

        })
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },

    }),
    mapping = cmp_mappings,
})
cmp.setup.filetype("lua",{
    mapping = cmp_mappings,
    sources = cmp.config.sources({
        { name = 'nvim_lua' },
        { name = 'nvim_lsp' },
    })
})



-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp_cmdline_mappings,
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp_cmdline_mappings,
    sources = cmp.config.sources({
        { name = 'path' },
        { name = 'cmdline',
            option = {
                ignore_cmds = { '!' }
            }}
    })
})



