-- Lua
return {
  "folke/persistence.nvim",
  event = "BufReadPre", -- this will only start session saving when an actual file was opened
  opts = {
    -- add any custom options here
  },
  config = function()
    require("persistence").setup {
      dir = vim.fn.expand(vim.fn.stdpath "data" .. "/sessions/"),
      need = 1,
      branch = true,
    }

    vim.keymap.set("n", "<leader>ps", function() require("persistence").load() end)
    vim.keymap.set("n", "<leader>pS", function() require("persistence").select() end)
    vim.keymap.set("n", "<leader>pl", function() require("persistence").load({ last = true }) end)
    vim.keymap.set("n", "<leader>pd", function() require("persistence").stop() end)
  end,
}
