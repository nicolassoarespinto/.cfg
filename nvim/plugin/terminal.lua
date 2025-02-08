local set = vim.opt_local

vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("custom-term-open", {}),
    callback = function()
        set.number = false
        set.relativenumber = false
        set.scrolloff = 0
        vim.bo.filetype = "terminal"
    end,
})

-- Easily hit escape in terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal' }) 

local function open_terminal()
    vim.cmd("vsplit term://bash")
end

-- Switch to existing terminal if it exists
local function switch_to_terminal()
    local term_buf = vim.fn.bufnr("term://")
    if term_buf ~= -1 then
        vim.cmd("echo 'Switching to terminal buffer.'")
        vim.api.nvim_set_current_buf(term_buf)
    else
        vim.cmd("echo 'No terminal buffer found. Opening new terminal.'")
        open_terminal()
    end
end

vim.keymap.set("n", "<leader>tn", open_terminal)
vim.keymap.set("n", "<leader>tt", switch_to_terminal)

