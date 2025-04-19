
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")



-- LSP 
--
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Navigation --
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- delete current buffer and open explorer, without closing the window
function LeaveBuffer()
    local buf_id = vim.api.nvim_get_current_buf()
    vim.cmd("Ex")
    vim.api.nvim_buf_delete(buf_id, { force = true })
end

vim.keymap.set("n", "<leader>pd", LeaveBuffer)



-- Navigation
-- Remove <C-l> from netrw keymap
-- vim.keymap.set('n', '<C-l>', '<nop>', { buffer = true })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Resize windows
vim.keymap.set('n', '<M-.>', '<c-w>5<', { desc = 'Resize window to the left' })
vim.keymap.set('n', '<M-,>', '<c-w>5>', { desc = 'Resize window to the right' })
vim.keymap.set('n', '<M-t>', '<C-W>+', { desc = 'Resize window to the top' })
vim.keymap.set('n', '<M-s>', '<C-W>-', { desc = 'Resize window to the bottom' })

vim.keymap.set('n', '<M-q>', '<C-w>q', { desc = 'Close window' })


-- Tabs
-- Go to next tab
vim.keymap.set('n', '<M-K>', ':tabnext<CR>', { desc = 'Go to next tab' })
vim.keymap.set('n', '<M-J>', ':tabprevious<CR>', { desc = 'Go to previous tab' })
vim.keymap.set('n', '<M-N>', ':tabnew<CR>', { desc = 'Open new tab' })
vim.keymap.set('n', '<M-W>', ':tabclose<CR>', { desc = 'Close tab' })
vim.keymap.set('n', 'gt', ':tabnext<CR>', { desc = 'Go to next tab' })


-- <C-D> and <C-U> to scroll hal a page, but keep the cursor in center
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
        vim.o.mouse = 'a'
        vim.api.nvim_echo({{'Paste mode disabled', 'Normal'}}, true, {})
    else
        vim.o.paste = true
        vim.wo.relativenumber = false
        vim.wo.number = false
        vim.o.mouse = ''
        vim.api.nvim_echo({{'Paste mode enabled', 'Normal'}}, true, {})
    end
end

vim.keymap.set('n', '<leader>pp', TogglePasteCopyMode, { desc = 'Toggle paste mode' }, {noremap = true, silent = true})
vim.keymap.set('i', '<F12>', TogglePasteCopyMode, { desc = 'Toggle paste mode' }, {noremap = true, silent = true})


-- Move in quickfix list
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")
-- Clear quickfix list
function ClearQuickfix()
    -- Ask for confirmation
    local confirm = vim.fn.input("Clear quickfix list? [y/n]: ")
    if confirm ~= "y" then
        return
    end
    vim.fn.setqflist({})
    print("Quickfix list cleared")
end

-- Set command
vim.keymap.set("n", "<leader>qf", ClearQuickfix, { desc = 'Clear quickfix list' })


-- Lua code --
vim.keymap.set("n", "<leader>x", ":.lua<CR>", { desc = 'Execute lua code' })
vim.keymap.set("v", "<leader>x", ":lua<CR>", { desc = 'Execute lua code' })
vim.keymap.set("n", "<leader><leader>x", "<cmd>source %<CR>", { desc = 'Execute current file'}, {noremap = true, silent = true})


