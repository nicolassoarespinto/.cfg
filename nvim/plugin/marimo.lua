-- Function to insert a new Marimo cell
function ToggleNotebookMode()
    if vim.g.notebook_target == nil or vim.g.notebook_target == 'marimo' then
        vim.g.notebook_target = 'quarto'
        vim.notify('Notebook set to quarto')
    else
        vim.g.notebook_target = 'marimo'
        vim.notify('Notebook set to marimo')
    end
end

-- Function to insert a new Marimo cell
function InsertCodeCell()
  -- Ensure notebook_target is set
  if vim.g.notebook_target == nil then
      ToggleNotebookMode()
  end
  -- Define the cell template
  local marimo_cell_template = {
    "```python {.marimo}",
    "",
    "```",
  }
  local quarto_cell_template = {
    "```{python} ",
    "#| echo: false",
    "",
    "```",
  }
    local cell_template = vim.g.notebook_target == 'marimo' and marimo_cell_template or quarto_cell_template
  -- Insert the cell template at the current cursor position
  vim.api.nvim_put(cell_template, 'l', true, true)
end

-- Function to find all code blocks using Treesitter
function FindCodeBlocks()
    local bufnr = vim.api.nvim_get_current_buf()
    local parser = vim.treesitter.get_parser(bufnr, 'markdown')
    
    if not parser then
        vim.notify('Treesitter parser not available for markdown', vim.log.levels.ERROR)
        return {}
    end
    
    local tree = parser:parse()[1]
    local root = tree:root()
    
    local code_blocks = {}
    
    -- Query for fenced code blocks
    local query = vim.treesitter.query.parse('markdown', [[
        (fenced_code_block) @code_block
    ]])
    
    for id, node, metadata in query:iter_captures(root, bufnr, 0, -1) do
        local start_row, start_col, end_row, end_col = node:range()
        
        -- Get the text content to check if it's our target type
        local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, start_row + 1, false)
        local first_line = lines[1] or ""
        
        -- Check if it's a python code block (for both marimo and quarto)
        if first_line:match("```%s*python") or first_line:match("```%s*{%s*python%s*}") then
            table.insert(code_blocks, {
                start_row = start_row,
                start_col = start_col,
                end_row = end_row,
                end_col = end_col,
                node = node
            })
        end
    end
    
    -- Sort by start position
    table.sort(code_blocks, function(a, b)
        return a.start_row < b.start_row
    end)
    
    return code_blocks
end

-- Function to find the current code block
function FindCurrentCodeBlock()
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1 -- Convert to 0-indexed
    local code_blocks = FindCodeBlocks()
    
    for i, block in ipairs(code_blocks) do
        if cursor_row >= block.start_row and cursor_row <= block.end_row then
            return block, i
        end
    end
    
    return nil, nil
end

-- Function to move to the next code block
function MoveToNextCodeBlock()
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local code_blocks = FindCodeBlocks()
    
    if #code_blocks == 0 then
        vim.notify('No code blocks found', vim.log.levels.WARN)
        return
    end
    
    -- Find the next code block after current cursor position
    for _, block in ipairs(code_blocks) do
        if block.start_row > cursor_row then
            vim.api.nvim_win_set_cursor(0, {block.start_row + 1, 0})
            return
        end
    end
    
    -- If no next block found, go to the first one
    vim.api.nvim_win_set_cursor(0, {code_blocks[1].start_row + 1, 0})
    vim.notify('Wrapped to first code block')
end

-- Function to move to the previous code block
function MoveToPrevCodeBlock()
    local cursor_row = vim.api.nvim_win_get_cursor(0)[1] - 1
    local code_blocks = FindCodeBlocks()
    
    if #code_blocks == 0 then
        vim.notify('No code blocks found', vim.log.levels.WARN)
        return
    end
    
    -- Find the previous code block before current cursor position
    for i = #code_blocks, 1, -1 do
        local block = code_blocks[i]
        if block.start_row < cursor_row then
            vim.api.nvim_win_set_cursor(0, {block.start_row + 1, 0})
            return
        end
    end
    
    -- If no previous block found, go to the last one
    local last_block = code_blocks[#code_blocks]
    vim.api.nvim_win_set_cursor(0, {last_block.start_row + 1, 0})
    vim.notify('Wrapped to last code block')
end

-- Function to delete the current code block
function DeleteCurrentCodeBlock()
    local current_block, block_index = FindCurrentCodeBlock()
    
    if not current_block then
        vim.notify('No code block found at cursor position', vim.log.levels.WARN)
        return
    end
    
    local bufnr = vim.api.nvim_get_current_buf()
    
    -- Delete the entire code block (including the lines)
    vim.api.nvim_buf_set_lines(bufnr, current_block.start_row, current_block.end_row + 1, false, {})
    
    vim.notify(string.format('Deleted code block at lines %d-%d', 
               current_block.start_row + 1, current_block.end_row + 1))
end

-- Function to select the current code block
function SelectCurrentCodeBlock()
    local current_block, block_index = FindCurrentCodeBlock()
    
    if not current_block then
        vim.notify('No code block found at cursor position', vim.log.levels.WARN)
        return
    end
    
    -- Enter visual line mode and select the entire code block
    vim.api.nvim_win_set_cursor(0, {current_block.start_row + 1, 0})
    vim.cmd('normal! V')
    vim.api.nvim_win_set_cursor(0, {current_block.end_row + 1, 0})
    
    vim.notify(string.format('Selected code block at lines %d-%d', 
               current_block.start_row + 1, current_block.end_row + 1))
end

-- Function to insert a new cell below the current code block
function InsertCellBelowCurrent()
    -- Find the current code block
    local current_block, block_index = FindCurrentCodeBlock()
    
    if current_block then
        -- Move cursor to the line after the current code block
        local insert_line = current_block.end_row + 1
        vim.api.nvim_win_set_cursor(0, {insert_line + 1, 0})
        
        -- Insert cell using existing function
        InsertCodeCell()
        
        vim.notify(string.format('Inserted new %s cell below current block', vim.g.notebook_target or 'marimo'))
    else
        -- No current code block found, fall back to original behavior
        InsertCodeCell()
        vim.notify(string.format('No current code block found, inserted %s cell at cursor', vim.g.notebook_target or 'marimo'))
    end
end

-- Create user commands
vim.api.nvim_create_user_command('InsertMarimoCell', InsertCodeCell, { desc = 'Insert a new Marimo cell' })
vim.api.nvim_create_user_command('InsertMarimoCellBelow', InsertCellBelowCurrent, { desc = 'Insert a new Marimo cell' })
vim.api.nvim_create_user_command('ToggleNotebookMode', ToggleNotebookMode, { desc = 'Toggle between Marimo and Quarto modes' })
vim.api.nvim_create_user_command('NextCodeBlock', MoveToNextCodeBlock, { desc = 'Move to next code block' })
vim.api.nvim_create_user_command('PrevCodeBlock', MoveToPrevCodeBlock, { desc = 'Move to previous code block' })
vim.api.nvim_create_user_command('DeleteCodeBlock', DeleteCurrentCodeBlock, { desc = 'Delete current code block' })
vim.api.nvim_create_user_command('SelectCodeBlock', SelectCurrentCodeBlock, { desc = 'Select current code block' })

function IsLikelyMarimoFile()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 50, false) -- Check first 50 lines
    
    for _, line in ipairs(lines) do
        -- Look for marimo-specific patterns
        if line:match("```python {%.marimo}") or 
           line:match("import marimo") or
           line:match("app = marimo%.App") then
            return true
        end
    end
    return false
end

function SetupNotebookKeymaps()
    local opts = { noremap = true, silent = true, buffer = true }
    
    -- Core mappings (always available for markdown)
    vim.keymap.set('n', '<M-T>', ':ToggleNotebookMode<CR>', opts)
    vim.keymap.set('n', '<M-I>', ':InsertMarimoCell<CR>', opts)
    vim.keymap.set('n', '<M-i>', ':InsertMarimoCellBelow<CR>', opts)
    
    -- Navigation and manipulation mappings
    vim.keymap.set('n', '<M-j>', ':NextCodeBlock<CR>', opts)
    vim.keymap.set('n', '<M-k>', ':PrevCodeBlock<CR>', opts)
    vim.keymap.set('n', '<M-d>', ':DeleteCodeBlock<CR>', opts)
    vim.keymap.set('n', '<M-s>', ':SelectCodeBlock<CR>', opts)
    
    -- Alternative mappings (vim-style)
    vim.keymap.set('n', ']c', ':NextCodeBlock<CR>', opts)
    vim.keymap.set('n', '[c', ':PrevCodeBlock<CR>', opts)
    -- Set notebook mode as marimo
    vim.g.notebook_target = 'marimo'
    vim.keymap.set('n', '<leader>jj', '<Plug>SlimeSendCell', { desc = 'Send current cell' }, opts)
end

vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
    pattern = "*.md",
    callback = function()
        -- Small delay to ensure buffer is fully loaded
        vim.defer_fn(function()
            if IsLikelyMarimoFile() then
                vim.notify('Marimo notebook detected - notebook keymaps activated', vim.log.levels.INFO)
                SetupNotebookKeymaps()
            end
        end, 100)
    end,
    desc = "Auto-detect marimo files and setup keymaps"
})

vim.api.nvim_create_user_command('ActivateNotebookMode', function()
    SetupNotebookKeymaps()
    vim.notify('Notebook keymaps activated for current buffer', vim.log.levels.INFO)
end, { desc = 'Manually activate notebook keymaps for current buffer' })





