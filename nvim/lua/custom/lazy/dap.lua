return {
    {
        'mfussenegger/nvim-dap',
        dependencies = {
            {
                'rcarriga/nvim-dap-ui',
                dependencies = { 'nvim-neotest/nvim-nio' },
            },
            {
                'mfussenegger/nvim-dap-python',
                ft = { "py" },
                config = function()
                    require("dap-python").setup("uv")
                    -- Show dap configuration
                    local dap = require("dap")
                    -- add justMyCode=False to existing configs
                    local orig =  dap.configurations.python
                    local updated = {} 
                    for i, config in ipairs(orig) do
                        config.justMyCode = false
                        table.insert(updated, config)
                    end
                    dap.configurations.python = updated
                end
            },
            {
                'jbyuki/one-small-step-for-vimkind',
            },
            'theHamsta/nvim-dap-virtual-text',
        },

        config = function()
            local dap = require('dap')
            local dapui = require('dapui')
            local repl = require('dap.repl')

            vim.keymap.set(
                'n',
                '<leader>tb',
                dap.toggle_breakpoint,
                { desc = 'Toggle setting a breakpoint using DAP' }
            )

            vim.keymap.set('n', '<leader>dj', dap.down)
            vim.keymap.set('n', '<leader>dk', dap.up)

            vim.keymap.set('n', '<leader>Db', dap.toggle_breakpoint)
            vim.keymap.set('n', '<leader>Dd', dap.down)
            vim.keymap.set('n', '<leader>Dn', dap.step_over)
            vim.keymap.set('n', '<leader>Dr', dap.repl.open)
            vim.keymap.set('n', '<leader>Ds', dap.step_into)
            vim.keymap.set('n', '<leader>Du', dap.up)

            vim.keymap.set('n', '<F5>', dap.continue)
            vim.keymap.set('n', '<F9>', dap.step_over)
            vim.keymap.set('n', '<F10>', dap.step_over)
            vim.keymap.set('n', '<F11>', dap.step_into)


            dapui.setup {}
            dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
            dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
            dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end

            -- Lua config 
            --
            vim.keymap.set('n', '<leader>dl', function() 
              require"osv".launch({port = 8086}) 
            end, { noremap = true })

			vim.keymap.set('n', '<leader>dw', function()
			  local widgets = require"dap.ui.widgets"
			  widgets.hover()
			end)

			vim.keymap.set('n', '<leader>df', function()
			  local widgets = require"dap.ui.widgets"
			  widgets.centered_float(widgets.frames)
			end)

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
