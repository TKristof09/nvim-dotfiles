return {
    {
        "folke/flash.nvim",
        opts = {
            search = {
                multi_window = false,
            },
            label = {
                exclude = "jJqQ",
                rainbow = {
                    enabled = true,
                }
            },
            modes = {
                char = {
                    enabled = false
                }
            }
        },
        config = function(_, opts)
            local Flash = require("flash")
            Flash.setup(opts)
            local function on_done(done, on_done)
                local check = assert(vim.loop.new_check())
                local fn = function()
                    if check:is_closing() then
                        return
                    end
                    if done() then
                        check:stop()
                        check:close()
                        on_done()
                    end
                end
                check:start(vim.schedule_wrap(fn))
            end

            local function format(opts)
                -- always show first and second label
                return {
                    { opts.match.label1, "FlashMatch" },
                    { opts.match.label2, "FlashLabel" },
                }
            end

            local hopWord = function()
                Flash.jump({
                    search = { mode = "search" },
                    label = { after = false, before = { 0, 0 }, uppercase = false, format = format },
                    pattern = [[\<]],
                    action = function(match, state)
                        state:hide()
                        Flash.jump({
                            search = { max_length = 0 },
                            highlight = { matches = false },
                            label = { format = format },
                            matcher = function(win)
                                -- limit matches to the current label
                                return vim.tbl_filter(function(m)
                                    return m.label == match.label and m.win == win
                                end, state.results)
                            end,
                            labeler = function(matches)
                                for _, m in ipairs(matches) do
                                    m.label = m.label2 -- use the second label
                                end
                            end,
                        })
                    end,
                    labeler = function(matches, state)
                        local labels = state:labels()
                        for m, match in ipairs(matches) do
                            match.label1 = labels[math.floor((m - 1) / #labels) + 1]
                            match.label2 = labels[(m - 1) % #labels + 1]
                            match.label = match.label1
                        end
                    end,
                })
            end


            vim.keymap.set({ "n", "x", "o" }, "sh", hopWord)
            vim.keymap.set({ "n", "x", "o" }, "ss", function() require("flash").jump() end)
            vim.keymap.set({ "n", "x", "o" }, "st", function() require("flash").treesitter() end)
            vim.keymap.set("o", "r", function() require("flash").remote() end)
            vim.keymap.set({ "o", "x" }, "R", function()
                local start_cursor = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
                on_done(function()
                    return vim.fn.mode(true):sub(1, 2) ~= "no"
                end, function()
                    vim.api.nvim_win_set_cursor(vim.api.nvim_get_current_win(), start_cursor)
                end)
                require("flash").treesitter_search()
            end)
        end,
        lazy = true,
        event = "VeryLazy"
    }
}
