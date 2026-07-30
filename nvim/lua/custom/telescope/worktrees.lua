local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local entry_display = require("telescope.pickers.entry_display")

-- Telescope picker for moving between existing git worktrees.
-- Mirrors the "move only" half of the bin/git-cd bash helper: it never
-- creates a worktree or branch, it only lists what `git worktree list`
-- already knows about and jumps there.

-- Parse `git worktree list --porcelain` into a list of
-- { path, branch, is_current, is_bare, is_detached }.
local function list_worktrees()
  local output = vim.fn.systemlist({ "git", "worktree", "list", "--porcelain" })
  if vim.v.shell_error ~= 0 then
    return nil, table.concat(output, "\n")
  end

  local cwd = vim.loop.cwd()
  local worktrees = {}
  local current

  for _, line in ipairs(output) do
    if line == "" then
      current = nil
    elseif vim.startswith(line, "worktree ") then
      current = { path = line:sub(#"worktree " + 1), branch = nil, is_bare = false, is_detached = false }
      table.insert(worktrees, current)
    elseif current then
      if line == "bare" then
        current.is_bare = true
      elseif line == "detached" then
        current.is_detached = true
      elseif vim.startswith(line, "branch ") then
        current.branch = line:sub(#"branch " + 1):gsub("^refs/heads/", "")
      end
    end
  end

  for _, wt in ipairs(worktrees) do
    wt.is_current = vim.fs.normalize(wt.path) == vim.fs.normalize(cwd)
  end

  return worktrees
end

local function switch_to(path)
  if not vim.loop.fs_stat(path) then
    vim.notify("Worktree path no longer exists: " .. path, vim.log.levels.ERROR)
    return
  end
  vim.cmd("cd " .. vim.fn.fnameescape(path))
  vim.notify("Switched worktree: " .. path, vim.log.levels.INFO)
end

local function switch_to_tab(path)
  if not vim.loop.fs_stat(path) then
    vim.notify("Worktree path no longer exists: " .. path, vim.log.levels.ERROR)
    return
  end
  vim.cmd("tabnew")
  vim.cmd("tcd " .. vim.fn.fnameescape(path))
end

local function worktrees_picker(opts)
  opts = opts or {}

  local worktrees, err = list_worktrees()
  if not worktrees then
    vim.notify("git worktree list failed: " .. (err or "unknown error"), vim.log.levels.ERROR)
    return
  end
  if vim.tbl_isempty(worktrees) then
    vim.notify("No git worktrees found", vim.log.levels.INFO)
    return
  end

  local displayer = entry_display.create({
    separator = "  ",
    items = {
      { width = 2 },
      { width = 30 },
      { remaining = true },
    },
  })

  local function make_display(entry)
    local wt = entry.value
    local marker = wt.is_current and "*" or ""
    local label = wt.is_bare and "(bare)" or wt.is_detached and "(detached)" or (wt.branch or "?")
    return displayer({
      marker,
      { label, wt.is_current and "TelescopeResultsSpecialComment" or "TelescopeResultsIdentifier" },
      { wt.path, "TelescopeResultsComment" },
    })
  end

  pickers
    .new(opts, {
      prompt_title = "Git Worktrees",
      finder = finders.new_table({
        results = worktrees,
        entry_maker = function(wt)
          return {
            value = wt,
            display = make_display,
            ordinal = (wt.branch or "") .. " " .. wt.path,
            path = wt.path,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = require("telescope.previewers").new_termopen_previewer({
        get_command = function(entry)
          return { "git", "-C", entry.value.path, "log", "--oneline", "--color=always", "-20" }
        end,
      }),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then
            switch_to(entry.value.path)
          end
        end)
        map({ "i", "n" }, "<C-t>", function()
          local entry = action_state.get_selected_entry()
          actions.close(prompt_bufnr)
          if entry then
            switch_to_tab(entry.value.path)
          end
        end)
        return true
      end,
    })
    :find()
end

return {
  pick = worktrees_picker,
  list = list_worktrees,
}
