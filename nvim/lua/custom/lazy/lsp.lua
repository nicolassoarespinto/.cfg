return {
    {
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
            { "Bilal2453/luvit-meta",                        lazy = true },
            "mason-org/mason.nvim",
            -- "williamboman/mason-lspconfig.nvim",
            "WhoIsSethDaniel/mason-tool-installer.nvim",
            { "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

            -- Autoformatting
            "stevearc/conform.nvim",

        },
        config = function()

            local cmp_capabilities = {}
            if pcall(require, "cmp_nvim_lsp") then
                cmp_capabilities = require("cmp_nvim_lsp").default_capabilities()
            end
            local capabilities = vim.tbl_deep_extend("force", 
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_capabilities
            )

            local lspconfig = require "lspconfig"

            local servers = {
                bashls = true,
                pylsp = {
                    cmd = { "python", "-m", "pylsp" },
                    settings = {
                        pylsp = {
                            plugins = {
                                pycodestyle = {
                                    ignore = {'W391'},
                                    maxLineLength = 100
                                }
                            }
                        }
                    }
                },
                lua_ls = {
                    capabilities = {
                        semanticTokensProvider = vim.NIL,
                    },
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            telemetry = {
                                enable = false,
                            },
                        },
                    }

                },
            }

            local servers_to_install = { 
                "lua-language-server",
                "python-lsp-server",
                "bash-language-server",
                "stylua"
            }

            require("mason").setup()
            require("mason-tool-installer").setup { 
                ensure_installed = servers_to_install
            }

            for name, config in pairs(servers) do
                if config == true then
                    config = {}
                end
                config = vim.tbl_deep_extend("force", {}, {
                    capabilities = capabilities,
                }, config)

                lspconfig[name].setup(config)
            end

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local bufnr = args.buf
                    local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

                    local settings = servers[client.name]
                    if type(settings) ~= "table" then
                        settings = {}
                    end

                    local builtin = require "telescope.builtin"
                    -- Debug message
                    vim.notify("LSP attached to buffer " .. bufnr .. " with client " .. client.name, vim.log.levels.INFO)

                    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
                    vim.keymap.set("n", "gr", builtin.lsp_references, { buffer = bufnr })
                    vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })

                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', { buffer = bufnr })
                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', { buffer = bufnr })
                    vim.keymap.set('n', '[w', '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>', { buffer = bufnr })
                    vim.keymap.set('n', '<leader>vd', '<cmd>lua vim.diagnostic.open_float()<CR>', { buffer = bufnr })
                    vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { buffer = bufnr })
                    vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { buffer = bufnr })
                    vim.keymap.set('n', '<leader>[a', '<cmd>lua vim.lsp.buf.code_action()<CR>', { buffer = bufnr })
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', { buffer = bufnr })
                    vim.keymap.set('i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', { buffer = bufnr })
                    vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<CR>',
                        { buffer = bufnr })


                end,
            })
            --- Basic remaps --
				--         vim.diagnostic.config({
				--         -- update_in_insert = true,
				-- float = {
				-- 	focusable = false,
				-- 	style = "minimal",
				-- 	border = "rounded",
				-- 	source = "always",
				-- 	header = "",
				-- 	prefix = "",
				-- },
				--         }) 
				--

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

            -- LSP Lines ---
            require("lsp_lines").setup()
            vim.diagnostic.config { virtual_text = true, virtual_lines = false }

            vim.keymap.set("", "<leader>l", function()
                local config = vim.diagnostic.config() or {}
                if config.virtual_text then
                    vim.diagnostic.config { virtual_text = false, virtual_lines = true }
                else
                    vim.diagnostic.config { virtual_text = true, virtual_lines = false }
                end
            end, { desc = "Toggle lsp_lines" })
        end,
    },
}
