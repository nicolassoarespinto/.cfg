local DEBUG_MODE = false

local float = require('utils.float')

local function debug_state(prefix)
    if not DEBUG_MODE then
        return
    end
    vim.notify(
        prefix .. ":\n" ..
        "buf_id: " .. tostring(float.state.buf_id) .. "\n" ..
        "win_id: " .. tostring(float.state.win_id) .. "\n" ..
        "visible: " .. tostring(float.state.visible) .. "\n" ..
        "buf valid: " .. tostring(float.state.buf_id and vim.api.nvim_buf_is_valid(float.state.buf_id)) .. "\n" ..
        "win valid: " .. tostring(float.state.win_id and vim.api.nvim_win_is_valid(float.state.win_id)),
        vim.log.levels.INFO
    )
    if float.is_valid() then
        vim.notify("buf type: " .. vim.api.nvim_buf_get_option(float.state.buf_id, 'buftype'), vim.log.levels.INFO)
    end
end


local function setup_terminal()
    -- Create a new terminal buffer if it doesn't exist
    debug_state("Before setup")
    if not float.is_valid() then
        float.create_floating_window({
            width = 120,
            height = 36
        })
    end

    local buftype = vim.api.nvim_buf_get_option(float.state.buf_id, 'buftype')
    if buftype ~= 'terminal' then
        vim.api.nvim_set_current_win(float.state.win_id)
        vim.fn.termopen(vim.o.shell, {
            on_exit = function()
                float.hide()
                float.clear()
            end
        })
    end
    vim.api.nvim_set_current_win(float.state.win_id)
    vim.api.nvim_command('startinsert')

    debug_state("After setup")
end

local function toggle_terminal()
    debug_state('toggle')

    if float.is_active() then
        debug_state('hide')
        float.hide()
    else
        setup_terminal()
    end
end



-- Set up user command
vim.api.nvim_create_user_command("Fterminal", toggle_terminal, {})
-- Set up the keymap
vim.keymap.set({"n", "t"}, '<Leader>tt', toggle_terminal, { noremap = true, silent = true, desc = "Toggle floating terminal" })
