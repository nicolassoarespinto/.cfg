local builtin = require("telescope.builtin")

-- .scratch is gitignored by convention, so fd/rg skip it by default.
-- Locate it by walking up from the current buffer instead of assuming cwd == project root.
local function find_scratch_dir()
  local start = vim.fn.expand("%:p:h")
  if start == "" then
    start = vim.loop.cwd()
  end
  local found = vim.fs.find(".scratch", {
    path = start,
    upward = true,
    type = "directory",
    stop = vim.loop.os_homedir(),
  })
  return found[1]
end

local function with_scratch_dir(fn)
  local dir = find_scratch_dir()
  if not dir then
    vim.notify("No .scratch directory found", vim.log.levels.WARN)
    return
  end
  fn(dir)
end

local function files(opts)
  opts = opts or {}
  with_scratch_dir(function(dir)
    builtin.find_files(vim.tbl_extend("force", {
      cwd = dir,
      prompt_title = "Scratch Files",
      hidden = true,
      no_ignore = true,
      path_display = { "absolute" },
    }, opts))
  end)
end

local function grep(opts)
  opts = opts or {}
  with_scratch_dir(function(dir)
    builtin.live_grep(vim.tbl_extend("force", {
      cwd = dir,
      prompt_title = "Scratch Grep",
      additional_args = function()
        return { "--hidden", "--no-ignore" }
      end,
    }, opts))
  end)
end

return {
  files = files,
  grep = grep,
}
