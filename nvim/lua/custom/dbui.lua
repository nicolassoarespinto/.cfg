local function tbl_index_of(tbl, val)
  for i, v in ipairs(tbl) do
    if v == val then return i end
  end
  return nil
end



local function switch_query_buffer(next_direction)
  local bufs = vim.fn.getbufinfo({ buflisted = 1 })
  -- notify of found bufs for logging
  local current = vim.api.nvim_get_current_buf()
  local query_bufs = {}

  -- Filter dbui-query-* buffers
  for _, b in ipairs(bufs) do
    if b.name:match("query%-") then
      table.insert(query_bufs, b.bufnr)
    end
  end

  table.sort(query_bufs)  -- sort by buffer number

  -- Find current index
  local idx = tbl_index_of(query_bufs, current)
  if not idx then return end

  local next_idx = (idx + next_direction - 1) % #query_bufs + 1
  vim.api.nvim_set_current_buf(query_bufs[next_idx])
end

-- Shortcuts: [q to go to previous, ]q to go to next
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "*-query-*",
  callback = function()
    vim.keymap.set("n", "<M-]>", function() switch_query_buffer(1) end, {
      buffer = true,
      desc = "Next dbui query buffer"
    })
    vim.keymap.set("n", "<M-[>", function() switch_query_buffer(-1) end, {
      buffer = true,
      desc = "Previous dbui query buffer"
    })
  end,
})

