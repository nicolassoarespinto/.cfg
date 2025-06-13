return {
    "zbirenbaum/copilot.lua",
    config = function()
        require("copilot").setup {
            filetypes = {
                python = true,
                markdown = true,
                matlab = true,
                javascript = true,
                typescript = true,
                julia = true,
                ["*"] = false,
            },
            suggestion = {
                enabled = true,
                auto_trigger = true,
                hide_during_completion = true,
                debounce = 75,
                trigger_on_accept = true,
                keymap = {
                    accept = "<S-Tab>",
                    accept_word = false,
                    accept_line = false,
                    next = "<M-]>",
                    prev = "<M-[>",
                    dismiss = "<M-/>",
                },
            },
            panel = { enabled = false },
            telemetry = { enabled = false }
        }
    end
}
