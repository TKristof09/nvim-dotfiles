return {
    {
        'saghen/blink.cmp',
        lazy = true,
        event = "VeryLazy",

        version = 'v0.*',
        opts = {
            keymap = {
                preset = nil,
                ['<CR>'] = { "fallback" }, --otherwise enter gets mapped to something
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-l>'] = { "select_prev" },
                ['<C-d>'] = { "select_next" },
                ['<C-w>'] = { "select_and_accept" },
                ['<C-x>'] = { "scroll_documentation_up" },
                ['<C-m>'] = { "scroll_documentation_down" },
                -- Navigate between snippet placeholder
                ['<C-f>'] = { "snippet_forward", "fallback" },
                ['<C-b>'] = { "snippet_backward", "fallback" },
            },

            appearance = {
                -- Sets the fallback highlight groups to nvim-cmp's highlight groups
                -- Useful for when your theme doesn't support blink.cmp
                -- will be removed in a future release
                use_nvim_cmp_as_default = true,
                -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'normal'
            },
            completion = {
                menu = {
                    draw = {
                        treesitter = { "lsp" },
                        columns = { { "label", "label_description", gap = 1 }, { "kind_icon", "kind" } },
                    },

                    winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenu,CursorLine:CmpSelect,Search:None',

                },

                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 0,
                },
            },
            signature = { enabled = true },

            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
                providers = {
                    path = {
                        opts = {
                            show_hidden_files_by_default = true,
                        }
                    },
                    snippets = {
                        opts = {
                            friendly_snippets = false,
                        },
                    }
                }
            },


        },
    }
}
