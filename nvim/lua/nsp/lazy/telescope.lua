return { 
    "nvim-telescope/telescope.nvim",
    -- "nvim-telescope/telescope-file-browser.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
    },
    config = function ()
        require('telescope').setup{}
        -- extensions ={
        --         file_browser = {
        --     theme = "ivy",
        --     hijack_netrw = false
        -- }
        -- }
        -- }
        require('telescope').load_extension('file_browser')

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', function() builtin.find_files({ follow = true }) end, {})
        vim.keymap.set('n', '<C-p>', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
        vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
        vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        vim.keymap.set('n', '<leader>fk', builtin.keymaps, {})
        --vim.keymap.set('n', '<C-p>', builtin.git_files, {})

        vim.keymap.set('n', '<leader>ft', function() require('telescope').extensions.file_browser.file_browser() end, {})

    end

}
