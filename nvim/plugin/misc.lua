--- Map to toggle "paste+copy mode" (norelativenumber, nonumber, paste)
function TogglePasteCopyMode()
  if vim.o.paste then
    vim.o.paste = false
    vim.opt.relativenumber = true
    vim.opt.number = true
    vim.o.mouse = 'a'
    vim.api.nvim_echo({ { 'Paste mode disabled', 'Normal' } }, true, {})
  else
    vim.o.paste = true
    vim.opt.relativenumber = false
    vim.opt.number = false
    vim.o.mouse = ''
    vim.api.nvim_echo({ { 'Paste mode enabled', 'Normal' } }, true, {})
  end
end

vim.keymap.set('n', '<leader>pp', TogglePasteCopyMode, { desc = 'Toggle paste mode' }, { noremap = true, silent = true })


