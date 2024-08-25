require('mason').setup({})

require('mason-lspconfig').setup({
    handlers = {
        function(server_name)
            require('lspconfig')[server_name].setup({
                globals = {"vim"},
            })
        end,
    }
})


local lsp_attach = function(client, bufnr)
  local opts = {buffer = bufnr}

  vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition() end', opts)
  vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover() end', opts)
  vim.keymap.set('n', '<leader>vws', '<cmd>lua vim.lsp.buf.workspace_symbol() end', opts)
  vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float() end', opts)
  vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float() end', opts)
  vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_next() end', opts)
  vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_prev() end', opts)
  vim.keymap.set('n', '<leader>vca', '<cmd>lua vim.lsp.buf.code_action() end', opts)
  vim.keymap.set('n', '<leader>vrrr', '<cmd>lua vim.lsp.buf.references() end', opts)
  vim.keymap.set('n', '<leader>vrrn', '<cmd>lua vim.lsp.buf.rename() end', opts)
  vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename() end', opts)
  vim.keymap.set('i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help() end', opts)
  vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true}) end', opts)

end


local cmp = require('cmp')

cmp.setup({
  sources = {
    {name = 'nvim_lsp'},
  },
  snippet = {
    expand = function(args)
      -- You need Neovim v0.10 to use vim.snippet
      vim.snippet.expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({}),
})





