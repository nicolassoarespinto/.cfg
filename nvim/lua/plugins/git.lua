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

            local gs = require('gitsigns')

            -- navigate hunks
            local nav_and_center = function(direction)
                gs.nav_hunk(direction, { preview = true })
                -- zz for centering screen
                -- wait a ms to ensure the hunk is loaded
                vim.defer_fn(function()
                    vim.cmd('normal! zz')
                end, 20)
            end
            vim.keymap.set('n', ']g', function() nav_and_center('next') end, { desc = 'Next Hunk' })
            vim.keymap.set('n', '[g', function() nav_and_center('prev') end, { desc = 'Next Hunk' })
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
    },
    {
        "esmuellert/codediff.nvim",
        cmd = "CodeDiff",
        keys = {
        {
            '<leader>gD',
            function()
                local branches = {}
                require('custom.telescope.git_branches').pick({
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require('telescope.actions')
                        local action_state = require('telescope.actions.state')
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            if not selection then return end
                            local branch = selection.name
                            actions.close(prompt_bufnr)
                            if #branches == 0 then
                                table.insert(branches, branch)
                                -- pick the second branch
                                require('custom.telescope.git_branches').pick({
                                    attach_mappings = function(prompt_bufnr2, _)
                                        actions.select_default:replace(function()
                                            local sel2 = action_state.get_selected_entry()
                                            if not sel2 then return end
                                            actions.close(prompt_bufnr2)
                                            vim.cmd('CodeDiff ' .. branches[1] .. '...' .. sel2.name)
                                        end)
                                        return true
                                    end,
                                    prompt_title = 'Target branch (will diff ' .. branch .. '...TARGET)',
                                })
                            end
                        end)
                        return true
                    end,
                    prompt_title = 'Base branch',
                })
            end,
            desc = 'CodeDiff: branch pair diff',
        },
        {
            '<leader>gC',
            function()
                local commits = {}
                require('telescope.builtin').git_commits({
                    attach_mappings = function(prompt_bufnr, _)
                        local actions = require('telescope.actions')
                        local action_state = require('telescope.actions.state')
                        actions.select_default:replace(function()
                            local selection = action_state.get_selected_entry()
                            if not selection then return end
                            local commit = selection.value
                            actions.close(prompt_bufnr)
                            if #commits == 0 then
                                table.insert(commits, commit)
                                require('telescope.builtin').git_commits({
                                    attach_mappings = function(prompt_bufnr2, _)
                                        actions.select_default:replace(function()
                                            local sel2 = action_state.get_selected_entry()
                                            if not sel2 then return end
                                            actions.close(prompt_bufnr2)
                                            vim.cmd('CodeDiff ' .. commits[1] .. ' ' .. sel2.value)
                                        end)
                                        return true
                                    end,
                                    prompt_title = 'Second commit (diff ' .. commit:sub(1, 7) .. ' → TARGET)',
                                })
                            end
                        end)
                        return true
                    end,
                    prompt_title = 'First commit (base)',
                })
            end,
            desc = 'CodeDiff: commit pair diff',
        },
        { '<leader>gh', '<cmd>CodeDiff history %<cr>', desc = 'CodeDiff: file history' },
    },
    opts = {
        keymaps = {
            view = {
                quit = "<C-q>",
                next_hunk = "]g",
                prev_hunk = "[g",
                next_file = "]f",
                prev_file = "[f",
            },
        },
    },
    config = function(_, opts)
        require('codediff').setup(opts)
        -- extra file navigation aliases applied after the diff view opens
        vim.api.nvim_create_autocmd('User', {
            pattern = 'CodeDiffOpen',
            callback = function(ev)
                local tabpage = ev.data and ev.data.tabpage or vim.api.nvim_get_current_tabpage()
                for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabpage)) do
                    local buf = vim.api.nvim_win_get_buf(win)
                    vim.keymap.set('n', '<M-j>', function() require('codediff').next_file() end,
                        { buffer = buf, silent = true, desc = 'CodeDiff: next file' })
                    vim.keymap.set('n', '<M-k>', function() require('codediff').prev_file() end,
                        { buffer = buf, silent = true, desc = 'CodeDiff: prev file' })
                end
            end,
        })
    end,
}
}
