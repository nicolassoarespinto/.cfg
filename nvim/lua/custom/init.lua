require("custom.set")
require("custom.remap")
require("custom.lazy_init")
require("custom.style")



--- Quick fix LSP -- Look at this later
local autocmd = vim.api.nvim_create_autocmd

autocmd('LspAttach', {
    callback = function(e)
         local opts = { buffer = e.buf }
          vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
          vim.keymap.set('n', '<leader>vws', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', opts)
          vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
          vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
          vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
          vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
          vim.keymap.set('n', '<leader>vca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
          vim.keymap.set('n', '<leader>vrrr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          vim.keymap.set('n', '<leader>vrrn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
          vim.keymap.set('i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
          vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<CR>', opts)

    end
})
