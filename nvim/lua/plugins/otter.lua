return {
  'jmbuhr/otter.nvim',
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
  },
  ft = { 'quarto', 'markdown' },
  config = function()
    require('otter').setup({
      -- Use default configuration
    --   vim.keymap.set('n', '<F10>', function()
    --     -- message
    --     vim.notify('trying to activate otter')
    --     require('otter').activate()
    --   end, { desc = '[o]tter [a]ctivate' })
    })
  end,
}
