return {
    "yetone/avante.nvim",
    enabled=false,
    event = "VeryLazy",
    lazy = false,
    version = false, -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
        -- add any opts here
        -- for example
        mode = "legacy",
        provider = "copilot",
        auto_suggestions_provider = false,
        selection = { enabled = true , hint_display="none"},
    },
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = "make",
    dependencies = {
        { "stevearc/dressing.nvim" },
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
    },
}
