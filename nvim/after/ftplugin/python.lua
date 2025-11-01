-- Extract Python function arguments and insert them above the function
local function extract_python_args()
  local ts = vim.treesitter
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  
  -- Find function definition at or below cursor
  local parser = ts.get_parser(bufnr, "python")
  local tree = parser:parse()[1]
  local root = tree:root()
  
  local query = ts.query.parse("python", "(function_definition parameters: (parameters) @params) @func")
  
  for id, node in query:iter_captures(root, bufnr) do
    local capture_name = query.captures[id]
    local start_row = node:range()
    
    if start_row >= row then
      if capture_name == "params" then
        local params_text = ts.get_node_text(node, bufnr)
        
        -- Extract parameter names and their default values
        local args = {}
        params_text = params_text:gsub("^%(", ""):gsub("%)$", "")
        for param in params_text:gmatch("([^,]+)") do
          param = param:gsub("^%s+", ""):gsub("%s+$", "") -- trim whitespace
          if param ~= "" and not param:match("^self$") and not param:match("^cls$") then
            if param:match("=") then
              -- Parameter has default value, use it
              table.insert(args, param)
            else
              -- No default value, just the parameter name
              table.insert(args, param .. "=" .. param)
            end
          end
        end
        
        if #args > 0 then
          -- Insert above the function
          local func_start_row = start_row
          for capture_id, func_node in query:iter_captures(root, bufnr) do
            if query.captures[capture_id] == "func" and func_node:range() >= row then
              func_start_row = func_node:range()
              break
            end
          end
          
          vim.api.nvim_buf_set_lines(bufnr, func_start_row, func_start_row, false, args)
          vim.notify("Inserted " .. #args .. " parameter assignments")
        end
        return
      end
    end
  end
  
  vim.notify("No function found")
end

-- Keymap
vim.keymap.set('n', '<F12>', 
    extract_python_args, 
    { desc = 'Extract function args above function', buffer=true }
)
