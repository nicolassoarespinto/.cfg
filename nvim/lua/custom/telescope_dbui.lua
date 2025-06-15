local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")
local previewers = require("telescope.previewers")
local make_entry = require("telescope.make_entry")


local displayer = entry_display.create({
  separator = " │ ",
  items = {
    { width = 25 },
    { remaining = true },
  },
})

local display = function(e)
  return displayer({
    e.name,
    e.content:sub(1, 80),
  })
end

local entry_maker = function(entry)
  return make_entry.set_default_entry_mt({
    value = entry.content,
    ordinal = entry.content,
    display = function()
      return displayer({
                entry.name,
                entry.content:sub(1,80)
            })
    end,
    bufnr = entry.bufnr,
    name = entry.name,
  }, {})
end


local previewer = previewers.new_buffer_previewer({
      define_preview = function(self, entry, _)
        if vim.api.nvim_buf_is_loaded(entry.bufnr) then
          local lines = vim.api.nvim_buf_get_lines(entry.bufnr, 0, -1, false)
          vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, lines)
          vim.bo[self.state.bufnr].filetype = "sql"
        end
      end,
    })


local function query_buffer_picker()
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  local entries = {}

  for _, buf in ipairs(bufs) do
    if buf.name:match("query%-") then
      local lines = vim.api.nvim_buf_get_lines(buf.bufnr, 0, -1, false)
      local content = table.concat(lines, " ")
      table.insert(entries, {
        display = function(entry)
          return entry.name .. ": " .. entry.content:sub(1, 80)
        end,
        ordinal = content,
        name = buf.name,
        content = content,
        bufnr = buf.bufnr,
        lnum = 1,
      })
    end
  end

  pickers.new({}, {
    prompt_title = "Search dbui-query Buffers",
    finder = finders.new_table({
      results = entries,
      entry_maker=entry_maker,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewer,
    attach_mappings = function(_, map)
      local actions = require("telescope.actions")
      local action_state = require("telescope.actions.state")
      map("i", "<CR>", function(prompt_bufnr)
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.api.nvim_set_current_buf(entry.bufnr)
      end)
      return true
    end,
  }):find()
end

-- Add a keybinding:
vim.keymap.set("n", "<leader>fq", query_buffer_picker, { desc = "Find in query buffers" })

