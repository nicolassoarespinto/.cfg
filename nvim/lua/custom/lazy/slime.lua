return 
  { -- send code from python/r/qmd documets to a terminal or REPL
    -- like ipython, R, bash
    'jpalardy/vim-slime',
    dev = false,
     init = function()
       vim.g.slime_target = 'neovim'
       vim.g.slime_no_mappings = true
       vim.g.slime_python_ipython = 1
     end,
     config = function()
      vim.g.slime_target = 'tmux'
      vim.g.slime_bracked_paste = 1
      require('custom.slime').setup({
            default_target = 'neovim',
            toggle_key = '<leader>ct',
            mark_key = '<leader>cm',
            set_key = '<leader>cs',
        })
    end,
  }

 
