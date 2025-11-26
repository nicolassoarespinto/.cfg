local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

-- Telescope picker for zoxide directories
local function zoxide_picker(opts)
  opts = opts or {}

  -- Collect zoxide entries
  local output = vim.fn.systemlist({ "zoxide", "query", "--list" })
  if vim.v.shell_error ~= 0 then
    vim.notify("zoxide not available", vim.log.levels.ERROR)
    return
  end

  if vim.tbl_isempty(output) then
    vim.notify("No zoxide entries found", vim.log.levels.INFO)
    return
  end

  local function open_oil(path)
    vim.cmd("Oil " .. vim.fn.fnameescape(path))
  end

  pickers.new(opts, {
    prompt_title = "Zoxide",
    finder = finders.new_table({
      results = output,
    }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry and entry[1] then
          -- Open Oil in-place without changing cwd
          open_oil(entry[1])
        end
      end)
      -- New tab with tab-scoped cwd (like Oil ~)
      map({ "i", "n" }, "<C-t>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry and entry[1] then
          local target = vim.fn.fnameescape(entry[1])
          vim.cmd("tabnew")
          vim.cmd("tcd " .. target)
          open_oil(entry[1])
        end
      end)
      -- Live grep in that directory
      map({ "i", "n" }, "<C-g>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry and entry[1] then
          builtin.live_grep({ cwd = entry[1] })
        end
      end)
      -- Find files in that directory
      map({ "i", "n" }, "<C-f>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry and entry[1] then
          builtin.find_files({ cwd = entry[1] })
        end
      end)
      return true
    end,
  }):find()
end

return zoxide_picker
