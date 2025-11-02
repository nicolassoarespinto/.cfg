-- close some filetypes with <q>
vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'PlenaryTestPopup',
    'help',
    'lspinfo',
    'man',
    'notify',
    'qf',
    'startuptime',
    'tsplayground',
    'checkhealth',
    'neotest-summary',
    'neotest-output-panel',
    'toggleterm',
    'blink-tree',
    'gitsigns-blame',
    'AvanteAsk',
    'AvanteInput',
    'markdown',
  },
  callback = function(event)
    local bo = vim.bo[event.buf]
    if bo.filetype ~= 'markdown' or bo.buftype == 'help' then
      -- bo.buflisted = false
      vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = event.buf, silent = true, nowait = true })
    end
  end,
})
