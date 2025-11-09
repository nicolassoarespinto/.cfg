return  {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            bigfile = { enabled = true },
            input = { enabled = true },
            quickfile = { enabled = true },
            scratch = {
                enabled = true,
                win = {
                    backdrop = false,
                    b = {
                        completion = false
                    }
                }
            }
        },

        keys = {
                    { "<leader>,s", function() Snacks.scratch() end, desc = "Open Scratch" },
                    { "<leader>f,", function() Snacks.scratch.select() end, desc = "Select Scratch" },
                },
}
