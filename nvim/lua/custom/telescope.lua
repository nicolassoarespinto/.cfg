
local data = assert(vim.fn.stdpath "data")

require('telescope').setup {
        defaults = {},
        extensions = {
            fzf = { },
            history = {
                path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
                limit = 100,
            },
        }
    }
   
pcall(require('telescope').load_extension('file_browser'))
pcall(require('telescope').load_extension('fzf'))
pcall(require('telescope').load_extension('smart_history'))

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff',
    function()
        builtin.find_files({
            follow = false,
            path_display = { "absolute" }
        })
    end)
 vim.keymap.set('n', '<leader>f[',
            function()
                local opts = require('telescope.themes').get_ivy({
                    cwd = vim.fn.stdpath("config"),
                })
                builtin.find_files(opts)
    end)

-- Search from home directorey
vim.keymap.set('n', '<leader>f]',
            function()
                local ignore_patterns = {"miniconda", "anaconda"}
                local opts = {
                    cwd = vim.fn.expand("$HOME"),
                    hidden = false,
                    file_ignore_patterns = ignore_patterns,
                    path_display = { "absolute" },
                    previewer = false,

                }
                require('telescope.builtin').find_files(opts)
    end)




vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fj', require "custom.telescope.multi-ripgrep", {})
vim.keymap.set('n', '<leader>ffg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})

vim.keymap.set('n', '<leader>ft', function() require('telescope').extensions.file_browser.file_browser() end, {})

