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
        javascript = true,
        typescript = true,
        julia = true,
        markdown = true,
        help = true,
        ["*"] = false,
      },
      suggestion = {
        enabled = false,
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
      telemetry = { enabled = false },
      nes = {
        enabled = false,
        move_count_threshold = 3,
      },
   keymap = {
          accept_and_goto = "<leader>p",
          accept = false,
          dismiss = "<Esc>",
    },
      }
    -- Clear copilot suggestion with Esc if visible, otherwise preserve default Esc behavior
    vim.keymap.set("n", "<esc>", function()
        if not require("copilot-lsp.nes").clear() then
            -- fallback to other functionality
        end
    end, { desc = "Clear Copilot suggestion or fallback" })
end,
}
