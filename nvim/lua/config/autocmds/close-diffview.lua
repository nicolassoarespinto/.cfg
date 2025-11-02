-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'DiffviewFiles',
  },
  callback = function(event)
    local bo = vim.bo[event.buf]
      vim.keymap.set('n', '<C-q>', '<cmd>DiffviewClose<cr>', { buffer = event.buf, silent = true, nowait = true })
      vim.keymap.set('n', '<F10>', '<cmd>DiffviewClose<cr>', { buffer = event.buf, silent = true, nowait = true })
      vim.keymap.set('n', '<C-c>', '<cmd>Git commit<cr>', { buffer = event.buf, silent = true, nowait = true })
  end,
})


vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'oil'
  },
  callback = function(event)
    local bo = vim.bo[event.buf]
      vim.keymap.set('n', '<C-g>', '<cmd>DiffviewOpen<cr>', { buffer = event.buf, silent = true, nowait = true })
      vim.keymap.set('n', '<F10>', '<cmd>DiffviewOpen<cr>', { buffer = event.buf, silent = true, nowait = true })
  end,
})
