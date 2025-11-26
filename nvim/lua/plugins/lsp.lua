return {
    "neovim/nvim-lspconfig",
    dependencies = {
        {
            -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    -- Load luvit types when the `vim.uv` word is found
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            },
        },
    },
    config = function()
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        if pcall(require, "blink.cmp") then
            capabilities = require("blink.cmp").get_lsp_capabilities(capabilities, true)
        end

        local servers = {
            r_language_server = true,
            bashls = true,
            ts_ls = true,
            markdown_oxide = true,
            pylsp = true,
            lua_ls = true,
        }

        local servers_to_install = {
            "lua-language-server",
            -- "python-lsp-server",
            "bash-language-server",
            "typescript-language-server",
            "stylua"
        }

        require("mason").setup()
        require("mason-tool-installer").setup {
            ensure_installed = servers_to_install
        }

        -- Set global capabilities for all LSP servers
        vim.lsp.config("*", {
            capabilities = capabilities,
        })

        for name, config in pairs(servers) do
            if config == true then
                config = {}
            end
            if next(config) ~= nil then
                local lsp_config = vim.tbl_deep_extend("force", {}, config)
                vim.lsp.config(name, lsp_config)
            end
            vim.lsp.enable(name)
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
                local bufnr = args.buf
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

                local settings = servers[client.name]
                if type(settings) ~= "table" then
                    settings = {}
                end
                -- Debug message
                -- if vi
                    -- vim.notify("LSP attached to buffer " .. bufnr .. " with client " .. client.name, vim.log.levels.INFO)

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
    end
}
