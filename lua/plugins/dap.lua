return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
            "nvim-neotest/nvim-nio",
            "williamboman/mason.nvim",
            "nvim-telescope/telescope-dap.nvim"
        },
        lazy = true,
        event = "VeryLazy",
        config = function()
            local dap = require "dap"
            local ui = require "dapui"

            require("dapui").setup()
            require("nvim-dap-virtual-text").setup()
            require('telescope').load_extension('dap')


            vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
            vim.keymap.set("n", "<leader>drc", dap.run_to_cursor, { desc = "DAP: Run to Cursor" })

            -- Eval var under cursor
            vim.keymap.set("n", "<leader>de", function()
                require("dapui").eval(nil, { enter = true })
            end, { desc = "DAP: Evaluate" })

            vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "DAP: Continue" })
            vim.keymap.set("n", "<leader>dsi", dap.step_into, { desc = "DAP: Step Into" })
            vim.keymap.set("n", "<leader>dso", dap.step_over, { desc = "DAP: Step Over" })
            vim.keymap.set("n", "<leader>dsu", dap.step_out, { desc = "DAP: Step Out" })
            vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
            vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
            vim.keymap.set("n", "<F12>", dap.step_out, { desc = "DAP: Step Out" })
            vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "DAP: Restart" })
            vim.keymap.set("n", "<leader>dq", dap.terminate, { desc = "DAP: Terminate" })

            dap.listeners.before.attach.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.launch.dapui_config = function()
                ui.open()
            end
            dap.listeners.before.event_terminated.dapui_config = function()
                ui.close()
            end
            dap.listeners.before.event_exited.dapui_config = function()
                ui.close()
            end


            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            dap.adapters.ocamlearlybird = {
                type = 'executable',
                command = 'ocamlearlybird',
                args = { 'debug' }
            }
            dap.configurations.ocaml = {
                {
                    name = 'OCaml Debug Bytecode',
                    type = 'ocamlearlybird',
                    request = 'launch',
                    cwd = "${workspaceFolder}",
                    stopOnEntry = true,
                    _debugLog = "/home/kristof/dap.log",
                    -- program = '${workspaceFolder}/_build/default/bin/main.bc',
                    program = function()
                        return coroutine.create(function(coro)
                            local opts = {}
                            pickers
                                .new(opts, {
                                    prompt_title = "Path to executable",
                                    finder = finders.new_oneshot_job({ "fd", "--no-ignore", "-e", "bc" }, {}),
                                    sorter = conf.generic_sorter(opts),
                                    attach_mappings = function(buffer_number)
                                        actions.select_default:replace(function()
                                            actions.close(buffer_number)
                                            coroutine.resume(coro, action_state.get_selected_entry()[1])
                                        end)
                                        return true
                                    end,
                                })
                                :find()
                        end)
                    end,
                },
            }
            dap.configurations.cpp = {
                {
                    name = "Launch an executable",
                    type = "cppdbg",
                    request = "launch",
                    cwd = "${workspaceFolder}",
                    program = function()
                        return coroutine.create(function(coro)
                            local opts = {}
                            pickers
                                .new(opts, {
                                    prompt_title = "Path to executable",
                                    finder = finders.new_oneshot_job({ "fd", "--hidden", "--no-ignore", "--type", "x" },
                                        {}),
                                    sorter = conf.generic_sorter(opts),
                                    attach_mappings = function(buffer_number)
                                        actions.select_default:replace(function()
                                            actions.close(buffer_number)
                                            coroutine.resume(coro, action_state.get_selected_entry()[1])
                                        end)
                                        return true
                                    end,
                                })
                                :find()
                        end)
                    end,
                },

            }

            dap.adapters.python = function(cb, config)
                if config.request == 'attach' then
                    ---@diagnostic disable-next-line: undefined-field
                    local port = (config.connect or config).port
                    ---@diagnostic disable-next-line: undefined-field
                    local host = (config.connect or config).host or '127.0.0.1'
                    cb({
                        type = 'server',
                        port = assert(port, '`connect.port` is required for a python `attach` configuration'),
                        host = host,
                        options = {
                            source_filetype = 'python',
                        },
                    })
                else
                    cb({
                        type = 'executable',
                        command = '/home/kristof/python-stuff/bin/python',
                        args = { '-m', 'debugpy.adapter' },
                        options = {
                            source_filetype = 'python',
                        },
                    })
                end
            end
            dap.configurations.python = {
                {
                    -- The first three options are required by nvim-dap
                    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
                    request = 'launch',
                    name = "Launch file",

                    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

                    program = "${file}", -- This configuration will launch the current file if used.
                    pythonPath = function()
                        -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                        -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                        -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                        local cwd = vim.fn.getcwd()
                        if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
                            return cwd .. '/venv/bin/python'
                        elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
                            return cwd .. '/.venv/bin/python'
                        else
                            return '/home/kristof/python-stuff/bin/python'
                        end
                    end,
                },
            }
        end,
    },
}
