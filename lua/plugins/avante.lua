return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = true,
    version = "*", -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
        provider = "copilot",
        copilot = {
            endpoint = "https://api.githubcopilot.com",
            model = "claude-3.5-sonnet",
            proxy = nil,
            allow_insecure = false,
            timeout = 60000,
            temperature = 0.1,
            max_tokens = 8192,
        },
        file_selector = {
            provider = "telescope",
            provider_opts = {}
        },
        windows = {
            ask = {
                start_insert = false,
            },
        },
        hints = { enabled = false },
        mappings = {
            ask = "<leader>aq",
            edit = "<leader>ae",
            diff = {
                ours = "<leader>aco",
                theirs = "<leader>act",
                all_theirs = "<leader>aca",
                both = "<leader>acb",
                cursor = "<leader>acc",
                next = "<leader>an",
                prev = "<leader>ap",
            },
        }
    },
    keys = {
        {
            "<leader>aa",
            function()
                return require("avante").toggle()
            end,
            desc = "Toggle Avante",
            mode = { "n", "v" },
        },
        {
            "<leader>aq",
            function()
                require("avante.api").ask()
            end,
            desc = "Avante ask",
            mode = { "n", "v" },
        },
        {
            "<leader>ae",
            function()
                require("avante.api").edit()
            end,
            desc = "Avante edit",
            mode = { "n", "v" },
        },
        {
            "<leader>ax",
            function()
                require("avante").get():clear_history()
            end,
            desc = "Avante edit",
            mode = { "n", "v" },
            ft = "Avante*"
        },
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    dependencies = {
        {
            "stevearc/dressing.nvim",
            opts = {
                input = {
                    enabled = false
                }
            }
        },
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua",      -- for providers='copilot'
    },
    config = function(_, opts)
        require("avante").setup(opts)
        -- vim.api.nvim_create_autocmd("FileType", {
        --     pattern = { "Avante" },
        --     callback = function(args)
        --         vim.api.nvim_set_option_value("laststatus", 0, { buf = args.buf })
        --     end,
        -- })
    end
}
