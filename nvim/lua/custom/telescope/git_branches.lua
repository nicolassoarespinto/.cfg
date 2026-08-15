local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local relative_date = require("custom.git_relative_date")

-- Local-branch picker with a compact last-commit-date column (e.g. "11h", "1d", "4w"),
-- used in place of telescope's builtin git_branches for the branch-diff pickers.

local function list_branches()
  local output = vim.fn.systemlist({
    "git", "for-each-ref", "refs/heads",
    "--sort=-committerdate",
    "--format=%(refname:short)%09%(committerdate:unix)",
  })
  if vim.v.shell_error ~= 0 then
    return nil, table.concat(output, "\n")
  end

  local current = vim.fn.systemlist({ "git", "branch", "--show-current" })[1]
  local branches = {}
  for _, line in ipairs(output) do
    local name, ts = line:match("^(.-)\t(%d+)$")
    if name then
      table.insert(branches, { name = name, commit_ts = tonumber(ts), is_current = name == current })
    end
  end
  return branches
end

local function branches_picker(opts)
  opts = opts or {}

  local branches, err = list_branches()
  if not branches then
    vim.notify("git for-each-ref failed: " .. (err or "unknown error"), vim.log.levels.ERROR)
    return
  end

  local displayer = entry_display.create({
    separator = "  ",
    items = {
      { width = 1 },
      { width = 5 },
      { remaining = true },
    },
  })

  local function make_display(entry)
    local b = entry.value
    local marker = b.is_current and "*" or ""
    return displayer({
      marker,
      { b.commit_ts and relative_date(b.commit_ts) or "", "TelescopeResultsNumber" },
      { b.name, b.is_current and "TelescopeResultsSpecialComment" or "TelescopeResultsIdentifier" },
    })
  end

  pickers
    .new(opts, {
      prompt_title = opts.prompt_title or "Git Branches",
      finder = finders.new_table({
        results = branches,
        entry_maker = function(b)
          return {
            value = b,
            display = make_display,
            ordinal = b.name,
            name = b.name,
          }
        end,
      }),
      sorter = conf.generic_sorter(opts),
      previewer = require("telescope.previewers").new_termopen_previewer({
        get_command = function(entry)
          return { "git", "log", "--oneline", "--color=always", "-20", entry.value.name }
        end,
      }),
      attach_mappings = opts.attach_mappings,
    })
    :find()
end

return {
  pick = branches_picker,
}
