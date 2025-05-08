return {
    {
        'saghen/blink.compat',
        -- use the latest release, via version = '*', if you also use the latest release for blink.cmp
        version = '*',
        lazy = true,
        opts = {},
    },
    {
        'saghen/blink.cmp',
        lazy = true,
        event = "VeryLazy",

        version = '1.*',
        opts = {
            keymap = {
                preset = "none",
                ['<CR>'] = { "fallback" }, --otherwise enter gets mapped to something and i cant press enter in insert mode
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-l>'] = { "select_prev" },
                ['<C-d>'] = { "select_next" },
                ['<C-w>'] = { "select_and_accept" },
                ['<C-m>'] = { "scroll_documentation_up" },
                ['<C-x>'] = { "scroll_documentation_down" },
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

                    -- winhighlight = 'Normal:CmpMenu,FloatBorder:CmpMenu,CursorLine:CmpSelect,Search:None',
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 50,
                    update_delay_ms = 50,
                    window = {
                        border = "padded",
                    }
                },
                list = {
                    selection = {
                        auto_insert = false,
                    }
                },
                accept = {
                    auto_brackets = {
                        enabled = false,
                    },
                },
            },
            signature = { enabled = true },
            cmdline = {
                keymap = {
                    preset = "none",
                    ['<CR>'] = { "fallback" }, --otherwise enter gets mapped to something
                    ['<C-l>'] = { "select_prev" },
                    ['<C-d>'] = { "select_next" },
                    ['<C-w>'] = { "select_and_accept" },
                },
                completion = {
                    menu = {
                        auto_show = true
                    }
                }
            },

            sources = {
                default = {
                    "lazydev",
                    "lsp",
                    "path",
                    "snippets",
                    "buffer",
                    -- 'copilot_chat',
                    "avante_commands",
                    "avante_mentions",
                    "avante_files",
                },
                per_filetype = {
                    codecompanion = { "codecompanion" }
                },
                providers = {
                    lazydev = {
                        name = "LazyDev",
                        module = "lazydev.integrations.blink",
                        -- make lazydev completions top priority (see `:h blink.cmp`)
                        score_offset = 100,
                    },
                    path = {
                        opts = {
                            show_hidden_files_by_default = true,
                            get_cwd = function(_)
                                return vim.fn.getcwd()
                            end,
                        }
                    },
                    snippets = {
                        opts = {
                            friendly_snippets = false,
                        },
                    },
                    -- copilot_chat = {
                    --     name = "copilot_chat",
                    --     module = "copilot_chat_provider",
                    -- },
                    avante_commands = {
                        name = "avante_commands",
                        module = "blink.compat.source",
                        score_offset = 90, -- show at a higher priority than lsp
                        opts = {},
                    },
                    avante_files = {
                        name = "avante_files",
                        module = "blink.compat.source",
                        score_offset = 100, -- show at a higher priority than lsp
                        opts = {},
                    },
                    avante_mentions = {
                        name = "avante_mentions",
                        module = "blink.compat.source",
                        score_offset = 1000, -- show at a higher priority than lsp
                        opts = {},
                    }
                }
            },


        },
    }
}
