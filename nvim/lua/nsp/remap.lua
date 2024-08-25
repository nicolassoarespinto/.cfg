vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")


-- Diagnostic keymaps
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

-- Navigation
-- vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
-- vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
-- vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
-- vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })




