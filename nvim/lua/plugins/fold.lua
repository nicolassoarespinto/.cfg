return {
    -- UFO folding
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
            "kevinhwang91/promise-async",
            {
                "luukvbaal/statuscol.nvim",
                config = function()
                    local builtin = require("statuscol.builtin")
                    require("statuscol").setup({
                        relculright = true,
                        segments = {
                            { text = { builtin.foldfunc },      click = "v:lua.ScFa" },
                            { text = { "%s" },                  click = "v:lua.ScSa" },
                            { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
                        },
                    })
                end,
            },
        },
        event = "BufReadPost",
        opts = {
            provider_selector = function()
                return { "treesitter", "indent" }
            end,
        },

        init = function()
            -- UFO folding
            vim.o.foldcolumn = "1" -- '0' is not bad
            vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
            vim.o.foldlevelstart = 99 -- Start with all folds open
            vim.o.foldenable = true
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        end,
        keys = {
            { "zR", function() require("ufo").openAllFolds() end,         desc = "open all folds" },
            { "zM", function() require("ufo").closeAllFolds() end,        desc = "close all folds" },
            { "zr", function() require("ufo").openFoldsExceptKinds() end, desc = "open folds except kinds" },
            { "zm", function() require("ufo").closeFoldsWith() end,       desc = "close folds with" },
        }
    }
}
