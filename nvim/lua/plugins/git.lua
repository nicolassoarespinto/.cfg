-- Adds git related signs to the gutter, as well as utilities for managing changes
return {
    {
        "tpope/vim-fugitive",
        requires = {
            "tpope/vim-rhubarb",
        },
        config = function()
            vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
        end
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            local opts = { signcolumn = false, current_line_blame = false }
            require('gitsigns').setup(opts)


            vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>', { desc = 'Preview Git Hunk' })
            vim.keymap.set('n', '<leader>gg', ':Gitsigns toggle_signs<CR>', { desc = 'Toggle Gitsigns' })
            vim.keymap.set('n', '<leader>gt', ':Gitsigns toggle_current_line_blame<CR>', { desc = 'Toggle Gitsigns' })
        end
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
            "nvim-lua/plenary.nvim",  -- required
            "sindrets/diffview.nvim", -- optional - for diff viewing
        },

        config = function()
            local function open_in_split()
                require('neogit').open({ kind = 'split' })
            end

            require('neogit').setup({
                integrations = {
                    diffview = true, -- Enable diffview integration
                },
                log_view = {
                    kind = "split",
                },
                reflog_view = {
                    kind = "split",
                },
                graph_style = 'unicode',

                commit_editor = {
                    kind = 'split',
                },
                popup = {
                    kind = 'split',
                },

            })

            vim.keymap.set('n', '<leader>gn', open_in_split, { desc = 'Open Neogit' })
        end
    },
    {
        'aaronhallaert/advanced-git-search.nvim',
        cmd = 'AdvancedGitSearch',
        dependencies = {
            'nvim-telescope/telescope.nvim',
            'sindrets/diffview.nvim',
        },
        keys = {
            { '<leader>gsl',  '<cmd>AdvancedGitSearch search_log_content_file<cr>', desc = 'Search log content (file)' },
            { '<leader>gsL',  '<cmd>AdvancedGitSearch search_log_content<cr>',      desc = 'Search log content (repo)' },
            { '<leader>gsdf', '<cmd>AdvancedGitSearch diff_commit_file<cr>',        desc = 'Diff with commit (file)' },
            { '<leader>gsdl', '<cmd>AdvancedGitSearch diff_commit_line',            'Diff with commit (line)' },
            { '<leader>gsb',  '<cmd>AdvancedGitSearch changed_on_branch<cr>',       desc = 'Changed on branch' },
            { '<leader>gsg',  '<cmd>AdvancedGitSearch show_custom_functions<cr>',   desc = 'Pick a picker' },
        },
        config = function()
            require('telescope').setup({
                extensions = {
                    advanced_git_search = {
                        show_builtin_git_pickers = true, -- show builtin pickers for show_custom_functions
                        diff_plugin = 'diffview',
                    },
                },
            })
            require('telescope').load_extension('advanced_git_search')
        end,
    }
}
