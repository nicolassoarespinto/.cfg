local M = {}

-- Store the previous target to allow toggling
M.previous_target = nil

-- Function to set slime target and configure it
function M.set_target(target)
    -- Store current target before changing
    M.previous_target = vim.g.slime_target

    -- Set new target
    vim.g.slime_target = target

    -- Reset configuration based on target
    if target == 'tmux' then
        vim.g.slime_target = 'tmux'
        default_socket = "default"
        vim.g.slime_default_config = {
            socket_name = default_socket,
            target_pane = "",
        }


    elseif target == 'neovim' then
        vim.g.slime_target = 'neovim'
        vim.g.slime_neovim_ignore_unlisted = true
    end

end

-- Function to toggle between tmux and neovim targets
function M.toggle_target()
    if vim.g.slime_target == 'tmux' then
        M.set_target('neovim')
        vim.notify("Slime target set to Neovim terminal", vim.log.levels.INFO)
    else
        M.set_target('tmux')
        vim.notify("Slime target set to tmux", vim.log.levels.INFO)
    end
end

function M.toggle_ipython()
    if vim.g.slime_python_ipython == 1 then
        vim.g.slime_python_ipython = 0
        vim.notify("Slime python target set to python", vim.log.levels.INFO)
    else
        vim.g.slime_python_ipython = 1
        vim.notify("Slime python target set to ipython", vim.log.levels.INFO)
    end
end

function M.setup_quarto()
      vim.b['quarto_is_python_chunk'] = true
      Quarto_is_in_python_chunk = function()
        require('otter.tools.functions').is_otter_language_context 'python'
      end

      vim.cmd [[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
      ]]


end


-- Setup function to initialize keymaps and default configuration
function M.setup(opts)
    opts = opts or {}

    -- Set default target
    local default_target = opts.default_target or 'neovim'
    M.set_target(default_target)
    M.setup_quarto()

    -- Common settings
    vim.g.slime_no_mappings = true
    vim.g.slime_python_ipython = 1

    -- Set up keymaps
    local keymaps = {
        toggle_target = opts.toggle_key or '<leader>ct',
        mark_terminal = opts.mark_key or '<leader>cm',
        set_terminal = opts.set_key or '<leader>cs',
        toggle_ipython = opts.toggle_ipython or '<leader>sp',
    }

    -- Define keymaps
    vim.keymap.set('n', keymaps.toggle_target, M.toggle_target,
        { desc = '[t]oggle slime target (tmux/neovim)' })

    vim.keymap.set('n', keymaps.mark_terminal, function()
        if vim.g.slime_target == 'neovim' then
            local job_id = vim.b.terminal_job_id
            if job_id then
                vim.notify("Terminal marked with job ID: " .. job_id, vim.log.levels.INFO)
            end
        end
    end, { desc = '[m]ark terminal' })

    vim.keymap.set('n', keymaps.toggle_ipython, M.toggle_ipython,
        { desc = '[s]witch python target (ipython/python)' })

end

return M
