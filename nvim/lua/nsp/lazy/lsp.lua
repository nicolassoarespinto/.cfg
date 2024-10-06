return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "jay-babu/mason-null-ls.nvim",
        "nvimtools/none-ls.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip"
    },

    config = function()

        require('mason').setup({})
          local lsp_attach = function(client, bufnr)
          local opts = {buffer = bufnr}

          -- Debug print
          vim.api.nvim_echo({{client.name .. ' is ready'}}, true, {})
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

        local lsp_capabilities = vim.lsp.protocol.make_client_capabilities()
        local default_setup = function(server_name)
            require('lspconfig')[server_name].setup({
                capabilities = lsp_capabilities,
            })
        end
        
        require('mason-lspconfig').setup({
            handlers = {default_setup},
        })



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

        require('mason-null-ls').setup({
        ensure_installed = {"black"}
        })
        local null_ls = require("null-ls")
        null_ls.setup({
        sources = {
            null_ls.builtins.formatting.black,
            },
        })



    end
}


