local term = vim.fn.getenv('TERM')

if term == 'xterm-256color' or term == 'tmux-256color' then
    vim.cmd('silent! colorscheme kanagawa-wave')
    vim.cmd('silent! set termguicolors')
else
    vim.cmd('silent! colorscheme seoul256')
end


-- vim.cmd('silent! colorscheme kanagawa-wave')
vim.cmd('silent! set background=dark')

