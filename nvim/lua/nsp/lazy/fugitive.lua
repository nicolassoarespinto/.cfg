return {
    "tpope/vim-fugitive",
    requires = {
        "tpope/vim-rhubarb",
    },
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
    end
}

