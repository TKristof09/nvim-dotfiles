return {
    {
        dir = "/mnt/H/Programming/ai-chat",
        config = function()
            local Chat = require("ai-chat").setup().Chat
            require("ai-chat").keymap_set({ "i", "n" }, "<C-s>", function(chat)
                chat:send()
                vim.cmd("stopinsert")
            end)
            require("ai-chat").keymap_set("n", "<leader>fa", function(chat)
                chat:add_file()
            end)
            require("ai-chat").keymap_set("n", "<leader>ax", function(chat)
                chat:clear()
            end)
            local provider = require("ai-chat.providers.gemini")
            provider.env.model = "gemini-2.5-pro-exp-03-25"
            provider.env.api_key = require("secrets").gemini_api_key
            -- local provider = require("ai-chat.providers.ollama")
            -- provider.env.model = "qwen2.5-coder:3b"
            -- local provider = require("ai-chat.providers.copilot")

            vim.keymap.set("n", "<leader>ac", function()
                Chat.toggle_last(provider, {
                    win_size = 100,
                    win_position = "right",
                    floating = false,
                    -- border = "rounded"
                })
            end)
        end,
        lazy = true,
        event = "VeryLazy"
    }
}
