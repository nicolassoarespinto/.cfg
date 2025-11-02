function ToggleAI()
      local flag = vim.g.blink_cmp_copilot_enabled

      if flag == nil or flag == true then
        vim.g.blink_cmp_copilot_enabled = false
      else
        vim.g.blink_cmp_copilot_enabled = true
      end
end

function ToggleNES()
    local flag = vim.g.copilot_nes_enabled
      if flag == nil or flag == true then
        vim.g.copilot_nes_enabled = false
      else
        vim.g.copilot_nes_enabled = true
      end
end


vim.api.nvim_create_user_command("ToggleAI", ToggleAI,  {desc = "Toggle Copilot"})
vim.api.nvim_create_user_command("ToggleNES", ToggleNES,  {desc = "Toggle NES"})
