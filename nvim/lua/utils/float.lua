local M = {}

-- Store window and buffer states
M.state = {
    win_id = nil,
    buf_id = nil,
    visible = false
}

M.win_opts = {}

-- Create a centered floating window
function M.create_floating_window(opts)
    opts = opts or {}
    
    -- Get editor dimensions
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    
    -- Calculate window size (default to 80% of screen)
    local win_height = opts.height or math.floor(height * 0.8)
    local win_width = opts.width or math.floor(width * 0.8)
    
    -- Calculate starting position to center the window
    local row = math.floor((height - win_height) / 2)
    local col = math.floor((width - win_width) / 2)
    
    -- Window configuration
    M.win_opts = {
        relative = 'editor',
        row = row,
        col = col,
        width = win_width,
        height = win_height,
        style = 'minimal',
        border = 'rounded'
    }
    
    -- Create or get buffer
    if not M.state.buf_id or not vim.api.nvim_buf_is_valid(M.state.buf_id) then
        M.state.buf_id = vim.api.nvim_create_buf(true, false)
    end
    
    -- Create window
    M.state.win_id = vim.api.nvim_open_win(M.state.buf_id, true, M.win_opts)
    M.state.visible = true
    
    -- Set window options
    -- vim.api.nvim_win_set_option(M.state.win_id, 'winblend', 0)
    -- vim.api.nvim_win_set_option(M.state.win_id, 'winhighlight', 'Normal:Normal')
    
    return { M.state.win_id, M.state.buf_id } 
end

-- Hide the floating window
function M.hide()
    if M.state.win_id and vim.api.nvim_win_is_valid(M.state.win_id) then
        vim.api.nvim_win_hide(M.state.win_id)
        M.state.visible = false
    end
end

-- Show the floating window
function M.show()
    if M.is_active() then
        return 
    end

    state = M.create_floating_window(M.win_opts)
    M.state.visible = true
end


function M.is_valid()
    return M.state.buf_id 
        and vim.api.nvim_buf_is_valid(M.state.buf_id)
        and M.state.win_id
        and vim.api.nvim_win_is_valid(M.state.win_id)
end

function M.is_active()
    return M.state.visible and M.is_valid()
end

function M.clear()
    if M.is_valid() then
        M.hide()
    end
    M.state = {
        win_id = nil,
        buf_id = nil,
        visible = false
    }
end

return M
