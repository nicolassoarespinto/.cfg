return {
    -- formatting time limit
    {
        --"neovim/nvim-lspconfig",
        "stevearc/conform.nvim",
        opts = {
            format = { timeout_ms = 60000 },
        },
    },
}
