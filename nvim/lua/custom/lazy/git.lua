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
      })

      vim.keymap.set('n', '<leader>gn', open_in_split, { desc = 'Open Neogit' })
    end
  }
}
