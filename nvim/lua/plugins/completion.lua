return {
{
    "saghen/blink.cmp",
    dependencies = {
      "saghen/blink.compat",
      "fang2hou/blink-copilot",
      "copilotlsp-nvim/copilot-lsp",
      "rafamadriz/friendly-snippets",
      "Kaiser-Yang/blink-cmp-dictionary",
    },
    version = '1.*',
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      require("custom.completion")
    end,
}
}


