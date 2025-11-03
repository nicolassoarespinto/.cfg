return {
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            {
                "AndreM222/copilot-lualine",
                dependencies = "zbirenbaum/copilot.lua",
            },
        },
        event = "UIEnter",
        opts = function()
            -- DAP UI filetypes where statusline should be disabled
            local dapui_filetypes = {
                "dapui_scopes",
                "dapui_stacks",
                "dapui_watches",
                "dapui_breakpoints",
                "dapui_console",
                "dapui_repl",
                "dap-repl",
            }

            -- Check if current buffer is a DAP UI window
            local function is_dapui()
                local ft = vim.bo.filetype
                for _, dap_ft in ipairs(dapui_filetypes) do
                    if ft == dap_ft then
                        return true
                    end
                end
                return false
            end

            return {
                options = {
                    globalstatus = false,
                    disabled_filetypes = {
                        statusline = dapui_filetypes,
                        winbar = {},
                    },
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = {
                        {
                            "branch",
                            cond = function()
                                return not is_dapui()
                            end,
                        },
                        {
                            "diff",
                            cond = function()
                                return not is_dapui()
                            end,
                        },
                        {
                            "diagnostics",
                            cond = function()
                                return not is_dapui()
                            end,
                        },
                    },
                    lualine_x = {
                        {
                            require("lazy.status").updates,
                            cond = function()
                                return require("lazy.status").has_updates() and not is_dapui()
                            end,
                            color = { fg = "#ff9e64" },
                        },
                        {
                            "copilot",
                            cond = function()
                                return not is_dapui()
                            end,
                        },
                        {
                            "encoding",
                            cond = function()
                                return not is_dapui()
                            end,
                        },
                        {
                            "fileformat",
                            cond = function()
                                return not is_dapui()
                            end,
                        },
                        "filetype",
                    },
                    lualine_y = {
                        {
                            "progress",
                            cond = function()
                                return not is_dapui()
                            end,
                        },
                    },
                    lualine_z = {
                        {
                            "location",
                            cond = function()
                                return not is_dapui()
                            end,
                        },
                    },
                },
            }
        end,
    },
}
