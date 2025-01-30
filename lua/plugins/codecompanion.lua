local active_handle = nil
local function o1_adapter()
    local adapters = require('codecompanion.adapters')

    -- Extend the Copilot adapter with specific parameters and handlers for o1 models
    local adapter = adapters.extend('copilot', {
        opts = { stream = false }, -- Stream not supported
        schema = {
            model = {
                default = 'o1-preview',
                choices = {
                    'o1-preview',
                    'o1-mini',
                },
            },
        },
        handlers = {
            ---Handler to remove system prompt from messages
            form_messages = function(_, messages)
                return {
                    messages = vim
                        .iter(messages)
                        :filter(function(message) return not (message.role and message.role == 'system') end)
                        :totable(),
                }
            end,
        },
    })

    -- Remove unsupported settings from the adapter schema
    local unsupported_settings = { 'temperature', 'max_tokens', 'top_p', 'n' }
    vim.iter(unsupported_settings):each(function(setting) adapter.schema[setting] = nil end)

    adapter.name = 'copilot_o1'
    return adapter
end

local function azure_deepseek_adapter()
    return require("codecompanion.adapters").extend("deepseek", {
        url = "https://DeepSeek-R1-student-llm.eastus2.models.ai.azure.com/v1/chat/completions",
        env = {
            url = "https://DeepSeek-R1-student-llm.eastus2.models.ai.azure.com/",
            api_key = require("secrets").azure_api_key,
        },
        opts = {
            stream = true
        },
        schema = {
            model = {
                default = "DeepSeek-R1-student-llm",
                choices = { "DeepSeek-R1-student-llm" }
            },
            max_tokens = {
                default = 4096,
            },
            temperature = {
                default = 0.3
            }
        }
    })
end
local function kluster_adapter()
    return require("codecompanion.adapters").extend("deepseek", {
        url = "https://api.kluster.ai/v1/chat/completions",
        env = {
            url = "https://api.kluster.ai",
            api_key = require("secrets").kluster_api_key,
        },
        opts = {
            stream = true
        },
        schema = {
            model = {
                default = "deepseek-ai/DeepSeek-R1",
                choices = { "deepseek-ai/DeepSeek-R1" }
            },
            max_tokens = {
                default = 8000,
            },
            max_completion_tokens = {
                mapping = "parameters",
                type = "integer",
                optional = true,
                default = 7999,
                desc =
                "The maximum number of tokens to generate in the chat completion. The total length of input tokens and generated tokens is limited by the model's context length.",
                validate = function(n)
                    return n > 0, "Must be greater than 0"
                end,
            },
            temperature = {
                default = 0.2
            }
        }
    })
end

local function github_marketplace_adapter()
    return require("codecompanion.adapters").extend("openai_compatible", {
        url = "https://models.inference.ai.azure.com/chat/completions",
        env = {
            url = "https://api.github.com/marketplace/models",
            api_key = require("secrets").github_api_key,
        },
        opts = {
            stream = true
        },
        schema = {
            model = {
                default = "DeepSeek-R1",
                choices = {
                    "DeepSeek-R1",
                },
            },
            temperature = {
                default = 0.3
            },
            max_tokens = {
                default = 4096,
            },
        }
    })
end
local function hyperbolic_adapter()
    return require("codecompanion.adapters").extend("openai_compatible", {
        env = {
            url = "https://api.hyperbolic.xyz",
            api_key = require("secrets").hyperbolic_api_key,
        },
        opts = {
            stream = true
        },
        schema = {
            model = {
                default = "Qwen/Qwen2.5-Coder-32B-Instruct",
                choices = {
                    "Qwen/Qwen2.5-Coder-32B-Instruct"
                },
            },
        }
    })
end

local function huggingface_adapter()
    return require("codecompanion.adapters").extend("huggingface", {
        env = {
            api_key = require("secrets").huggingface_api_key
        },
        schema = {
            model = {
                default = "Qwen/Qwen2.5-Coder-32B-Instruct",
                choices = {
                    "Qwen/Qwen2.5-72B-Instruct",
                    "Qwen/Qwen2.5-Coder-32B-Instruct",
                    "deepseek-ai/DeepSeek-R1-Distill-Qwen-32B",
                }
            }
        }
    })
end

local function gemini_adapter()
    return require("codecompanion.adapters").extend("gemini", {
        env = {
            api_key = require("secrets").gemini_api_key,
        },
        schema = {
            model = {
                default = "gemini-2.0-flash-thinking-exp-01-21",
                choices = {
                    "gemini-2.0-flash-thinking-exp-01-21",
                    "gemini-exp-1206",
                },
            }
        },
    })
end

return {
    -- "olimorris/codecompanion.nvim",
    dir = "/mnt/H/Programming/codecompanion.nvim/",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "zbirenbaum/copilot.lua",
        'echasnovski/mini.diff',
    },
    opts = {
        opts = {
            log_level = "DEBUG",
        },
        display = {
            chat = {
                window = {
                    opts = {
                        number = false,
                        foldmethod = "marker",
                        foldmarker = "<think>,</think>",
                        foldtext =
                        [[substitute(getline(v:foldstart),'<think>','Thoughts: ','') . ' (' . (v:foldend - v:foldstart + 1) . ' lines)']]
                    }
                },
            },
            diff = {
                provider = "mini_diff"
            }

        },
        adapters = {
            huggingface = huggingface_adapter,
            copilot = function()
                return require("codecompanion.adapters").extend("copilot", {
                    schema = {
                        model = {
                            default = "claude-3.5-sonnet"
                        },
                        max_tokens = {
                            default = 8192
                        }
                    }
                })
            end,
            copilot_o1 = o1_adapter,
            kluster = kluster_adapter,
            hyperbolic = hyperbolic_adapter,
            azure_deepseek = azure_deepseek_adapter,
            github = github_marketplace_adapter,
            gemini = gemini_adapter,
        },
        strategies = {
            chat = {
                adatper = "huggingface",
                slash_commands = {
                    ["file"] = {
                        callback = "strategies.chat.slash_commands.file",
                        description = "Select a file using Telescope",
                        opts = {
                            provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua'
                            contains_code = true,
                        },
                    },
                },
            },
            inline = {
                adapter = "copilot"
            }
        },
        history = {
            auto_generate_title = false,
            file_path = vim.fn.stdpath("data") .. "/codecompanion_chats.json" -- History storage location
        },
    },
    keys = {
        {
            "<leader>at",
            function()
                local chat = require("codecompanion").toggle()
                if chat then
                    require("codecompanion_history").enable_autosave(chat)
                end
            end,
            desc = "Toggle CodeCompanion",
            mode = { "n", "v" },
        },
        {
            "<leader>al",
            function()
                require("codecompanion_history").open_saved_chats()
            end,
            desc = "Toggle CodeCompanion",
            mode = { "n", "v" },
        },
        {
            "<leader>af",
            function()
                local codecompanion = require("codecompanion")
                local chat = codecompanion.last_chat()
                if not chat then
                    chat = codecompanion.chat()
                end

                local commands = require("codecompanion.completion").slash_commands()
                for _, command in ipairs(commands) do
                    if command.label == "/file" then
                        require("codecompanion.completion").slash_commands_execute(command, chat)
                        break
                    end
                end
            end,
            desc = "Add file to CodeCompanion",
            mode = { "n" }
        },
    },
    lazy = true,
    event = "VeryLazy",
    config = function(_, opts)
        require("codecompanion").setup(opts)

        local progress = require("fidget.progress")

        -- Set up the autocmd group
        local group = vim.api.nvim_create_augroup("CodeCompanionProgress", { clear = true })
        -- Listen for request started event
        vim.api.nvim_create_autocmd("User", {
            pattern = "CodeCompanionRequestStarted",
            group = group,
            callback = function()
                local handle = progress.handle.create({
                    title = "CodeCompanion",
                    message = "Processing request...",
                    lsp_client = { name = "CodeCompanion" },
                })
                active_handle = handle
            end,
        })

        -- Listen for request finished event
        vim.api.nvim_create_autocmd("User", {
            pattern = "CodeCompanionRequestFinished",
            group = group,
            callback = function()
                local handle = active_handle
                if handle then
                    handle:finish()
                    active_handle = nil
                end
            end,
        })
    end
}
