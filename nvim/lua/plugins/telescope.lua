return {

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make"
            },
            {
                "nvim-telescope/telescope-smart-history.nvim",
                build = "make"
            },
            {
                "tami5/sqlite.lua",
            }
        },
        config = function()
            require "custom.telescope"
            require "custom.telescope_dbui"
        end,
    },
    -- smarter fuzzy search
    {
        'nvim-telescope/telescope-fzy-native.nvim',
        lazy = true,
        dependencies = {
            {
                'romgrk/fzy-lua-native',
                build = {
                    'make',
                    -- otherwise lazy.nvim will complain on checkout
                    -- https://github.com/romgrk/fzy-lua-native/issues/23
                    'git update-index --assume-unchanged static/libfzy-*.so',
                },
            },
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            vim.schedule(function() require('telescope').load_extension('fzy_native') end)
        end,
    },


    {
        'bassamsdata/namu.nvim',
        keys = {
            {
                '<leader>sn',
                function() require('namu.namu_symbols').show() end,
                desc = 'Symbols (Document)',
            },
            {
                '<leader>sw',
                function() require('namu.namu_workspace').show() end,
                desc = "LSP Symbols - Workspace",
            },
        },
        opts = {
            namu_symbols = {
                enable = true,
                options = {
                    display = { mode = 'icon' },
                    -- window = { border = { ' ' } },
                    AllowKinds = {
                        rust = {
                            'Function',
                            'Struct',
                            'Enum',
                            'Trait',
                            'Module',
                        },
                    },
                },
            },
            ui_select = { enable = true },
        },
    }

}
