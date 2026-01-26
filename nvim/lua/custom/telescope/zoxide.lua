local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local builtin = require("telescope.builtin")

-- Telescope picker for zoxide directories
local function open_oil(path)
  vim.cmd("Oil " .. vim.fn.fnameescape(path))
end

local function open_oil_tab(path)
  local target = vim.fn.fnameescape(path)
  vim.cmd("tabnew")
  vim.cmd("tcd " .. target)
  open_oil(path)
end

local function resolve_entry_path(entry, cwd)
  if not entry then
    return nil
  end
  local path = entry.path or entry.value or entry[1]
  if not path or path == "" then
    return nil
  end
  if cwd and not vim.startswith(path, "/") then
    path = vim.fs.joinpath(cwd, path)
  end
  return vim.fs.normalize(path)
end

local ignore_patterns = {
  ".git",
  ".venv",
  -- Add more patterns here when needed.
}

local function dir_find_command(opts)
  opts = opts or {}
  local patterns = opts.ignore_patterns or ignore_patterns
  if vim.fn.executable("fdfind") == 1 then
    local cmd = { "fdfind", "--type", "d", "--hidden", "--follow" }
    for _, pattern in ipairs(patterns) do
      table.insert(cmd, "--exclude")
      table.insert(cmd, pattern)
    end
    return cmd
  end
  if vim.fn.executable("fd") == 1 then
    local cmd = { "fd", "--type", "d", "--hidden", "--follow" }
    for _, pattern in ipairs(patterns) do
      table.insert(cmd, "--exclude")
      table.insert(cmd, pattern)
    end
    return cmd
  end
  local cmd = { "find", ".", "-type", "d" }
  for _, pattern in ipairs(patterns) do
    table.insert(cmd, "-not")
    table.insert(cmd, "-path")
    table.insert(cmd, "*/" .. pattern .. "/*")
  end
  return cmd
end

local function refine_picker(opts)
  opts = opts or {}
  local cwd = opts.cwd or vim.loop.cwd()
  if not cwd then
    vim.notify("No directory available for refine search", vim.log.levels.ERROR)
    return
  end

  pickers.new(opts, {
    prompt_title = opts.prompt_title or "Refine directory",
    finder = finders.new_oneshot_job(dir_find_command(opts), { cwd = cwd }),
    sorter = conf.generic_sorter(opts),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local path = resolve_entry_path(entry, cwd)
        if path then
          open_oil(path)
        end
      end)
      -- New tab with tab-scoped cwd (like Oil ~)
      map({ "i", "n" }, "<C-t>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local path = resolve_entry_path(entry, cwd)
        if path then
          open_oil_tab(path)
        end
      end)
      -- Live grep in that directory
      map({ "i", "n" }, "<C-g>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local path = resolve_entry_path(entry, cwd)
        if path then
          builtin.live_grep({ cwd = path })
        end
      end)
      -- Find files in that directory
      map({ "i", "n" }, "<C-s>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        local path = resolve_entry_path(entry, cwd)
        if path then
          builtin.find_files({ cwd = path })
        end
      end)
      return true
    end,
  }):find()
end

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
      map({ "i", "n" }, "<C-s>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry and entry[1] then
          builtin.find_files({ cwd = entry[1] })
        end
      end)
      -- Refine search within that directory (dirs only)
      map({ "i", "n" }, "<C-f>", function()
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if entry and entry[1] then
          refine_picker({
            cwd = entry[1],
            prompt_title = "Refine: " .. entry[1],
          })
        end
      end)
      return true
    end,
  }):find()
end

return {
  pick = zoxide_picker,
  refine = refine_picker,
}

-- TODO:
-- C-f -> refine search. search dirs only than enable C-g/C-s/C-t inside
-- C-s -> find_files
-- Version with just C-f from cwd inside oil
