local lsp = require('lsp-zero').preset("minimal")
local lsp_signature = require("lsp_signature")
require("mason").setup()

-- lsp_signature.setup({
--     bind = true,
--     handler_opts = {
--         border = "single"
--     },
--     select_signature_key = "<M-n>"
-- })


lsp.on_attach(function(client, bufnr)
    -- see :help lsp-zero-keybindings
    -- to learn the available actions
    local opts = {buffer = bufnr, remap = false, silent = true}

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

    if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, bufnr)
    end

end)

lsp.set_sign_icons({
    error = '✘',
    warn = '▲',
    hint = '⚑',
    info = '»'
})

lsp.set_server_config({
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true
            }
        },
        offsetEncoding = {'utf-16'}
    },
    offsetEncoding = {'utf-16'}
})


require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        lsp.default_setup,
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
        pylsp = function ()
            require('lspconfig').pylsp.setup{
                settings = {
                    pylsp = {
                        plugins = {
                            pycodestyle = {
                                enabled = false
                            },
                        }
                    }
                }
            }

        end,
        lua_ls = function()
            local lua_opts = lsp.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end
    },
})





lsp.setup()
vim.lsp.inlay_hint.enable(true)


local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_select = {behavior = cmp.SelectBehavior.Select}
local cmp_mappings = cmp.mapping.preset.insert({
    ['<C-l>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-d>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-w>'] = cmp.mapping.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace }),
    ["<C-n>"] = cmp.mapping.complete(),
    ['<C-x>'] = cmp.mapping.scroll_docs(4),
    ['<C-m>'] = cmp.mapping.scroll_docs(-4),
    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
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

