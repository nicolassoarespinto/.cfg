return { 
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        {"nvim-telescope/telescope-fzf-native.nvim",
        build = "make"
        },
        {"nvim-telescope/telescope-smart-history.nvim",
        build = "make"
        }
    },
    config = function ()
        local data = assert(vim.fn.stdpath "data")
        require('telescope').load_extension('file_browser')
        require('telescope').load_extension('fzf')
        require('telescope').load_extension('smart_history')
        require('telescope').setup{
            defaults = {},
            extensions = {
                fzf = {
                },
                history = {
                    path = vim.fs.joinpath(data, "telescope_history.sqlite3"),
                    limit=100,
                },
            }
        }
        -- extensions ={
        --         file_browser = {
        --     theme = "ivy",
        --     hijack_netrw = false
        -- }
        -- }
        -- }

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ follow = false, path_display, path_display= {"absolute"} }) end, {})
        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fj', require "custom.telescope.multi-ripgrep", {})
        vim.keymap.set('n', '<leader>ffg', builtin.git_files, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
        --vim.keymap.set('n', '<C-p>', builtin.git_files, {})

        vim.keymap.set('n', '<leader>ft', function() require('telescope').extensions.file_browser.file_browser() end, {})

    end

}
