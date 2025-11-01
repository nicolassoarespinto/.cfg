local del_qf_item = function()
  local items = vim.fn.getqflist()
  local line = vim.fn.line('.')
  table.remove(items, line)
  vim.fn.setqflist(items, "r")
  vim.api.nvim_win_set_cursor(0, { line, 0 })
end

function ToggleQuickfix()
  local qf_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    if vim.bo[buf].buftype == "quickfix" then
      qf_win = win
      break
    end
  end

  if qf_win then
    vim.cmd("cclose")
  else
    vim.cmd("copen")
  end
end


-- Clear quickfix list
function ClearQuickfix()
  -- Ask for confirmation
  local confirm = vim.fn.input("Clear quickfix list? [y/n]: ")
  if confirm ~= "y" then
    return
  end
  vim.fn.setqflist({})
  print("Quickfix list cleared")
end


vim.keymap.set("n", "dd", del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })
vim.keymap.set("v", "D", del_qf_item, { silent = true, buffer = true, desc = "Remove entry from QF" })
vim.keymap.set("n", "<leader>qf", ClearQuickfix, { desc = 'Clear quickfix list' })

-- Move in quickfix list
vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>")
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>")

-- Create User command
vim.api.nvim_create_user_command('ToggleQuickFix', ToggleQuickfix, { desc = 'Toggle quick fix list' })
local opts = { noremap = true, silent = true}
vim.keymap.set('n', '<leader>qq', ':ToggleQuickFix<CR>', opts)
