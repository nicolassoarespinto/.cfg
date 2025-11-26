vim.g.mapleader = " "

vim.opt.number = true
vim.opt.ruler = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true


vim.opt.ignorecase = true
vim.opt.signcolumn = 'yes'
vim.opt.hlsearch = true
vim.opt.incsearch = true
--vim.opt.termguicolors = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

vim.opt.mouse = "a"
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300


vim.opt.splitright = true
vim.opt.splitbelow = true


vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"


-- vim.opt.formatoptions:remove "o"
-- vim.opt.foldmethod = "manual"

--- Terminals ---
--vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>")
-- Login-shell helper: open :terminal with bash -l when needed
vim.api.nvim_create_user_command('TermLogin', function(opts)
  local args = opts.args ~= "" and (" " .. opts.args) or ""
  vim.cmd("terminal bash -l" .. args)
end, { nargs = "*", desc = "Open bash -l terminal (uses ~/.bash_profile)" })


-- Slime ---
vim.g.slime_python_ipython = 1

-- Move in quickfix list
vim.keymap.set("n", "<C-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<C-k>", "<cmd>cprev<CR>")
