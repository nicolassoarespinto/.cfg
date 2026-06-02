local data = assert(vim.fn.stdpath "data")
local actions = require('telescope.actions')

require('telescope').setup {
    defaults = {
        mappings = {
            -- Use <C-l> for vertical splits and disable the default <C-v> binding
            i = { ['<C-l>'] = actions.select_vertical, ['<C-v>'] = false,
                ["<C-Down>"] = require('telescope.actions').cycle_history_next,
                ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
            },
            n = { ['<C-l>'] = actions.select_vertical, ['<C-v>'] = false,
                ["<C-Down>"] = require('telescope.actions').cycle_history_next,
                ["<C-Up>"] = require('telescope.actions').cycle_history_prev,
            },
        },
    },
    extensions = {
        fzf = {},
        history = {
            path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
            limit = 1000,
        },
    }
}

pcall(require('telescope').load_extension('file_browser'))
pcall(require('telescope').load_extension('fzf'))
pcall(require('telescope').load_extension('smart_history'))

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff',
    function()
        local ignore_patterns = { "miniconda", "anaconda", "node_modules", ".venv", ".json", ".parquet", ".pyc" }
        builtin.find_files({
            follow = false,
            file_ignore_patterns = ignore_patterns,
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
vim.keymap.set('n', '<leader>f.',
    function()
        local ignore_patterns = { "miniconda", "anaconda", "node_modules", ".venv", ".json", ".parquet", ".pyc" }
        local opts = {
            cwd = vim.fn.expand("$HOME"),
            hidden = false,
            file_ignore_patterns = ignore_patterns,
            path_display = { "absolute" },
            previewer = false,

        }
        require('telescope.builtin').find_files(opts)
    end)


local telescope_meta_picker = function()
    -- Picker for telescope pickers
    pickers = {}
end

vim.keymap.set('n', '<leader>fg',
    function()
        builtin.live_grep({
            file_ignore_patterns = { "node_modules", ".git", ".venv", "miniconda3", ".json", ".parquet", ".pyc" }
        })
    end)

vim.keymap.set('n', '<leader>fj', require "custom.telescope.multi-ripgrep", {})
vim.keymap.set('n', '<leader>fz', function()
    require("custom.telescope.zoxide").pick()
end, { desc = 'Zoxide picker' })
vim.keymap.set('n', '<leader>ffg', builtin.git_files, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
vim.keymap.set('n', '<leader>fs', builtin.lsp_references, {})
vim.keymap.set('n', '<leader>ffj', builtin.git_status, {})
vim.keymap.set('n', '<leader>f]',
    function()
        local opts = { previewer = false }
        builtin.builtin(opts)
    end
)
vim.keymap.set('n', '<leader>f;', '<cmd>Telescope commands<cr>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>fc', '<cmd>Telescope command_history<cr>', { desc = 'Command History' })
vim.keymap.set('n', '<leader>fm', '<cmd>Telescope marks<cr>', { desc = 'Jump to Mark' })
vim.keymap.set('n', '<leader>f/', function()
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
        winblend = 10,
        previewer = false,
    }))
end, { desc = 'Search Current Buffer' })
