local lsp = require("custom.lsp")
lsp.setup()

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr })
    vim.keymap.set('n', '[w', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { buffer = bufnr })
    vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float()<CR>', { buffer = bufnr })
    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.jump({count=1})<CR>', { buffer = bufnr })
    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.jump({count=-1})<CR>', { buffer = bufnr })
    vim.keymap.set('n', '<leader>[a', '<cmd>lua vim.lsp.buf.code_action()<CR>', { buffer = bufnr })
    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', { buffer = bufnr })
    vim.keymap.set('i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { buffer = bufnr })
    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<CR>',
      { buffer = bufnr })
    if pcall(require, "namu.namu_symbols") then
      vim.keymap.set('n', '<leader>sn', function() require('namu.namu_symbols').show() end,
        { buffer = bufnr, desc = 'Symbols (Document)' })

      vim.keymap.set('n', '<leader>sd', function() require('namu.namu_diagnostics').show() end,
        { buffer = bufnr, desc = 'Symbols (Document)' })
    end
  end,
})

vim.g.diagnostics_active = false
vim.diagnostic.enable(false)
function Toggle_diagnostics()
  if vim.g.diagnostics_active then
    vim.g.diagnostics_active = false
    vim.diagnostic.enable(false)
  else
    vim.g.diagnostics_active = true
    vim.diagnostic.enable(true)
  end
end

vim.keymap.set('n', '<leader>xd', Toggle_diagnostics,
  { noremap = true, silent = true, desc = "Toggle vim diagnostics" })
vim.keymap.set('n', '<leader>bf', ':lua vim.lsp.buf.format()<CR>', { desc = 'Format buffer' })
