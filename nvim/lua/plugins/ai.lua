return {
        "folke/sidekick.nvim",
        event="VeryLazy",
        init = function()
            vim.g.sidekick_nes = false
        end,
        config = function(_, opts)
                require("sidekick").setup(opts)
        end,
        opts = {
            -- add any options here
            cli = {
                mux = {
                    backend = "tmux",
                    enabled = true,
                },
            },
            nes = {
            enabled = function(buf)
                    return not not(vim.g.sidekick_nes ~= false and vim.b.sidekick_nes ~= false)
                end
            },
            jump = {
                jumplist = true,
            }
        },
        keys = {
            {
                "<leader>sx",
                function() require("sidekick.nes").clear() end,
                desc = "Sidekick clear NES",
            },
            {
                "<leader>su",
                function() require("sidekick.nes").update() end,
                desc = "Sidekick update NES",
            },
            {
                "<leader>al",
                function() require("sidekick.cli").toggle() end,
                desc = "Sidekick Toggle CLI",
            },
            {
                "<leader>ad",
                function() require("sidekick.cli").close() end,
                desc = "Detach a CLI ession",
            },
        },
}
