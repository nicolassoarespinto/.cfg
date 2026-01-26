return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'mfussenegger/nvim-dap-python',
                ft = { "py" },
                config = function()
                    require("dap-python").setup("uv")
                    -- Show dap configuration
                    local dap = require("dap")
                    -- add justMyCode=False to existing configs
                    local orig = dap.configurations.python
                    local updated = {}
                    for i, config in ipairs(orig) do
                        config.justMyCode = false
                        table.insert(updated, config)
                    end
                    dap.configurations.python = updated
                end
            },
            {
                'igorlfs/nvim-dap-view',
                opts = {
                winbar = {
                  sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "sessions", "console" },
                  default_section = "scopes",
                    controls = {
                        enabled = true,
                        position = "right",
                        buttons = {
                            "play",
                            "step_into",
                            "step_over",
                            "step_out",
                            "step_back",
                            "run_last",
                            "terminate",
                            "disconnect",
                        },
                        custom_buttons = {},
                    },
             
                },
                windows = {
                  terminal = {
                    size = 0.2,
                    position = "left",
                    hide = {},
                  },
                },
                auto_toggle = true,
              },
            },
            {
                'jbyuki/one-small-step-for-vimkind',
            },
            'theHamsta/nvim-dap-virtual-text',
        },

        config = function()
            local dap = require('dap')
            local repl = require('dap.repl')
            local dapview_key = "<leader>du"
            local dapview_key_active = false
            local dap_keymaps_active = false

            local function enable_dapview_keymap()
                if dapview_key_active then
                    return
                end
                vim.keymap.set("n", dapview_key, function()
                    require("dap-view").toggle()
                end, { desc = "Toggle DAP View", noremap = true, silent = true })
                dapview_key_active = true
            end

            local function disable_dapview_keymap()
                if not dapview_key_active then
                    return
                end
                pcall(vim.keymap.del, "n", dapview_key)
                dapview_key_active = false
            end

            local function enable_dap_keymaps()
                if dap_keymaps_active then
                    return
                end
                vim.keymap.set('n', '<leader>dj', dap.down)
                vim.keymap.set('n', '<leader>dk', dap.up)
                vim.keymap.set('n', '<C-n>', dap.run_to_cursor)
                vim.keymap.set('n', '<F9>', dap.step_over)
                vim.keymap.set('n', '<F10>', dap.step_over)
                vim.keymap.set('n', '<F11>', dap.step_into)

                vim.keymap.set('n', '<leader>dl', function()
                    require "osv".launch({ port = 8086 })
                end, { noremap = true })

                vim.keymap.set('n', '<leader>dw', function()
                    local widgets = require "dap.ui.widgets"
                    widgets.hover()
                end)

                vim.keymap.set('n', '<leader>df', function()
                    local widgets = require "dap.ui.widgets"
                    widgets.centered_float(widgets.frames)
                end)

                dap_keymaps_active = true
            end

            local function disable_dap_keymaps()
                if not dap_keymaps_active then
                    return
                end
                pcall(vim.keymap.del, "n", "<leader>dj")
                pcall(vim.keymap.del, "n", "<leader>dk")
                pcall(vim.keymap.del, "n", "<C-n>")
                pcall(vim.keymap.del, "n", "<F9>")
                pcall(vim.keymap.del, "n", "<F10>")
                pcall(vim.keymap.del, "n", "<F11>")
                pcall(vim.keymap.del, "n", "<leader>dl")
                pcall(vim.keymap.del, "n", "<leader>dw")
                pcall(vim.keymap.del, "n", "<leader>df")
                dap_keymaps_active = false
            end

            dap.listeners.after.event_initialized["dapview_keymap"] = function()
                enable_dapview_keymap()
            end
            dap.listeners.before.event_terminated["dapview_keymap"] = function()
                disable_dapview_keymap()
            end
            dap.listeners.before.event_exited["dapview_keymap"] = function()
                disable_dapview_keymap()
            end

            dap.listeners.after.event_initialized["dap_keymaps"] = function()
                enable_dap_keymaps()
            end
            dap.listeners.before.event_terminated["dap_keymaps"] = function()
                disable_dap_keymaps()
            end
            dap.listeners.before.event_exited["dap_keymaps"] = function()
                disable_dap_keymaps()
            end

            vim.keymap.set(
                'n',
                '<leader>tb',
                dap.toggle_breakpoint,
                { desc = 'Toggle setting a breakpoint using DAP' }
            )
            vim.keymap.set('n', '<F5>', dap.continue)
            vim.keymap.set('n', '<F6>', function()
                if dap.session() then
                    dap.terminate()
                end
                pcall(function()
                    require("dap-view").close()
                end)
            end, { desc = "Stop DAP session" })


            -- dapui.setup {}
            -- dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
            -- dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
            -- dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

            -- Lua config
            --

            dap.configurations.lua = {
                {
                    type = 'nlua',
                    request = 'attach',
                    name = "Attach to running Neovim instance",
                }
            }


            dap.adapters.nlua = function(callback, config)
                callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
            end
        end,
    },
}
