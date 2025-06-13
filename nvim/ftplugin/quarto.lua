local api = vim.api
local ts = vim.treesitter

vim.b.slime_cell_delimiter = '```'
vim.b['quarto_is_r_mode'] = nil


-- wrap text, but by word no character
-- indent the wrappped line
vim.wo.wrap = true
vim.wo.linebreak = true
vim.wo.breakindent = true
-- vim.wo.showbreak = '|'

-- don't run vim ftplugin on top
vim.api.nvim_buf_set_var(0, 'did_ftplugin', true)

-- markdown vs. quarto hacks
-- local ns = vim.api.nvim_create_namespace 'QuartoHighlight'
-- vim.api.nvim_set_hl(ns, '@markup.strikethrough', { strikethrough = false })
-- vim.api.nvim_set_hl(ns, '@markup.doublestrikethrough', { strikethrough = true })
-- vim.api.nvim_win_set_hl_ns(0, ns)

-- vim.api.nvim_set_hl(0, '@markup.codecell', { bg = '#000055' })
-- vim.api.nvim_set_hl(0, '@markup.codecell', {
  -- link = 'CursorLine',
-- })

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt_local.foldenable = true
vim.opt_local.foldlevel = 99
vim.opt_local.foldlevelstart = 99


-- Run :ActivateNotebookMode user cmd
vim.cmd("ActivateNotebookMode")
vim.g.notebook_target = 'quarto'

