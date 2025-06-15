return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make"
        },
        {
            "nvim-telescope/telescope-smart-history.nvim",
            build = "make"
        },
        {
            "tami5/sqlite.lua",
        }
    },
    config = function()
        require "custom.telescope"
        require "custom.telescope_dbui"
    end

}
