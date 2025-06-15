return  {
    {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            -- A list of parser names, or "all"
            ensure_installed = { "javascript","python","rust","c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },
           -- Install parsers synchronously (only applied to `ensure_installed`)
            sync_install = false,

            -- Automatically install missing parsers when entering buffer
            -- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
            auto_install = true,

            indent = {
                enable = true
            },

            highlight = {
                -- `false` will disable the whole extension
                enable = true,

                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = { "markdown" },
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-Space>",    -- Start selection (Ctrl+Space)
                    node_incremental = "<CR>",  -- Expand selection to parent node
                    scope_incremental = false,       -- Disabled (optional scope expansion)
                    node_decremental = "<BS>",       -- Shrink selection (Backspace)
                },
            },
        })

        local treesitter_parser_config = require("nvim-treesitter.parsers").get_parser_configs()
        treesitter_parser_config.templ = {
            install_info = {
                url = "https://github.com/vrischmann/tree-sitter-templ.git",
                files = {"src/parser.c", "src/scanner.c"},
                branch = "master",
            },
        }

        vim.treesitter.language.register("templ", "templ")
    end
},

{
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                textobjects = {
                    -- Navigate between functions, classes, etc.
                    move = {
                        enable = true,
                        set_jumps = true, -- Add jumps to jumplist
                        
                        -- Go to next start
                        goto_next_start = {
                            ["]f"] = "@function.outer",      -- Next function start
                            ["]c"] = "@class.outer",         -- Next class start
                            ["]a"] = "@parameter.inner",     -- Next parameter/argument
                            ["]l"] = "@loop.outer",          -- Next loop start
                            ["]s"] = "@statement.outer",     -- Next statement
                            ["]m"] = "@function.outer",      -- Alternative for function (like built-in ]m)
                        },
                        
                        -- Go to next end
                        goto_next_end = {
                            ["]F"] = "@function.outer",      -- Next function end
                            ["]C"] = "@class.outer",         -- Next class end
                            ["]A"] = "@parameter.inner",     -- Next parameter end
                            ["]L"] = "@loop.outer",          -- Next loop end
                            ["]M"] = "@function.outer",      -- Alternative for function end
                        },
                        
                        -- Go to previous start
                        goto_previous_start = {
                            ["[f"] = "@function.outer",      -- Previous function start
                            ["[c"] = "@class.outer",         -- Previous class start
                            ["[a"] = "@parameter.inner",     -- Previous parameter
                            ["[l"] = "@loop.outer",          -- Previous loop start
                            ["[s"] = "@statement.outer",     -- Previous statement
                            ["[m"] = "@function.outer",      -- Alternative for function
                        },
                        
                        -- Go to previous end
                        goto_previous_end = {
                            ["[F"] = "@function.outer",      -- Previous function end
                            ["[C"] = "@class.outer",         -- Previous class end
                            ["[A"] = "@parameter.inner",     -- Previous parameter end
                            ["[L"] = "@loop.outer",          -- Previous loop end
                            ["[M"] = "@function.outer",      -- Alternative for function end
                        },
                    },
                    
                    -- Select text objects (bonus feature)
                    select = {
                        enable = true,
                        lookahead = true, -- Automatically jump forward to textobj
                        
                        keymaps = {
                            -- Select functions
                            ["af"] = "@function.outer",      -- Select entire function
                            ["if"] = "@function.inner",      -- Select function body
                            
                            -- Select classes
                            ["ac"] = "@class.outer",         -- Select entire class
                            ["ic"] = "@class.inner",         -- Select class body
                            
                            -- Select parameters/arguments
                            ["aa"] = "@parameter.outer",     -- Select parameter with comma
                            ["ia"] = "@parameter.inner",     -- Select parameter content
                            
                            -- Select loops
                            ["al"] = "@loop.outer",          -- Select entire loop
                            ["il"] = "@loop.inner",          -- Select loop body
                            
                            -- Select statements
                            ["as"] = "@statement.outer",     -- Select entire statement
                            
                            -- Select comments
                            ["a/"] = "@comment.outer",       -- Select comment
                        },
                    },
                },
            })
        end
    }

}
