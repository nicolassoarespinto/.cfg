
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- LSP 
--
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })


vim.g.diagnostics_active = true

function Toggle_diagnostics()
    if vim.g.diagnostics_active then
        vim.g.diagnostics_active = false
        vim.diagnostic.disable()
   else
        vim.g.diagnostics_active = true
        vim.diagnostic.enable()
    end
end

vim.keymap.set('n', '<leader>xd', Toggle_diagnostics, { noremap = true, silent = true, desc = "Toggle vim diagnostics" })

vim.keymap.set('n', '<leader>bf', ':lua vim.lsp.buf.format()<CR>', { desc = 'Format buffer' })

-- Terminal --
-- Open terminal in vertical split
vim.keymap.set('n', '<leader>tt', ':vsplit term://bash<CR>', { desc = 'Open terminal' }) 
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal' }) 

-- Navigation --
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- delete current buffer and open explorer, without closing the window
function LeaveBuffer()
    local buf_id = vim.api.nvim_get_current_buf()
    vim.cmd("Ex")
    vim.api.nvim_buf_delete(buf_id, { force = true })
end

vim.keymap.set("n", "<leader>pd", LeaveBuffer)



-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- <C-D> and <C-U> to scroll half a page, but keep the cursor in center
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')

vim.keymap.set('n', 'n', 'nzz')
vim.keymap.set('n', 'N', 'Nzz')


-- Paragraphs
vim.api.nvim_set_keymap('n', 'ç', '}', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'Ç', '{', { noremap = true, silent = true })  



-- Vim slime
-- send current line and move down

vim.keymap.set('n', '<F8>', ':SlimeSendCurrentLine<CR>j', { desc = 'Send current line' }, {noremap = true, silent = true})
vim.keymap.set('v', '<F8>', '<Plug>SlimeRegionSend<CR>gv<ESC>', { desc = 'Send current selection' }, {noremap = true, silent = true})


vim.keymap.set('n', '<leader>ji', '<Plug>SlimeParagraphSend}', { desc = 'Send current line' }, {noremap = true, silent = true})




-- slimeconfig to <leader>ss
vim.keymap.set('n', '<leader>ss', ':SlimeConfig<CR>', { desc = 'Slime config' })



--- Map to toggle "paste+copy mode" (norelativenumber, nonumber, paste)
function TogglePasteCopyMode()
    if vim.o.paste then
        vim.o.paste = false
        vim.wo.relativenumber = true
        vim.wo.number = true
        vim.api.nvim_echo({{'Paste mode disabled', 'Normal'}}, true, {})
    else
        vim.o.paste = true
        vim.wo.relativenumber = false
        vim.wo.number = false
        vim.api.nvim_echo({{'Paste mode enabled', 'Normal'}}, true, {})
    end
end

vim.keymap.set('n', '<leader>pp', TogglePasteCopyMode, { desc = 'Toggle paste mode' }, {noremap = true, silent = true})
vim.keymap.set('i', '<F12>', TogglePasteCopyMode, { desc = 'Toggle paste mode' }, {noremap = true, silent = true})
