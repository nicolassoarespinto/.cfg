return {
  "zbirenbaum/copilot.lua",
  dependencies = {
        { "copilotlsp-nvim/copilot-lsp",
            init = function ()
                vim.g.copilot_nes_debounce = 500
            end,
        }
    },
  event = "InsertEnter",
  config = function()
    require("copilot").setup {
      filetypes = {
        python = true,
        -- markdown = true,
        matlab = true,
        lua = true,
        javascript = true,
        typescript = true,
        julia = true,
        markdown = false,
        help = false,
        ["*"] = false,
      },
      suggestion = {
        enabled = false,
        auto_trigger = false,
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
      telemetry = { enabled = false },
   keymap = {
          accept_and_goto = "<leader>p",
          accept = false,
          dismiss = "<Esc>",
    },
      }
    -- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
    -- vim.keymap.set("n", "<esc>", function()
    --     if not require("copilot-lsp.nes").clear() then
    --             -- fallback to other functionality
    --             vim.cmd("nohlsearch")
    --     end
    -- end, { desc = "Clear Copilot suggestion or fallback" })
    local active = true
    vim.keymap.set("n", "<leader>co", function()
      if active then
        require("copilot.command").disable()
        vim.g.blink_cmp_copilot_enabled = false
        active = false
        vim.notify("Copilot disabled", vim.log.levels.INFO)
      else
        require("copilot.command").enable()
        vim.g.blink_cmp_copilot_enabled = true
        active = true
        vim.notify("Copilot enabled", vim.log.levels.INFO)
      end
    end, { desc = "Toggle Copilot", silent = true })
end,
}
