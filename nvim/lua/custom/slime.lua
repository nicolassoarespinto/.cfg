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

-- Function to get terminal info for display
local function get_terminal_info(term)
  local bufname = vim.api.nvim_buf_get_name(term.bufnr)
  -- Extract shell name from terminal buffer name (format is usually "term://path//pid:shell")
  local shell = bufname:match(':([^:]+)$') or bufname:match('([^/:]+)$') or 'terminal'
  -- Remove common shell command prefixes
  shell = shell:gsub('^.*/', ''):gsub('%s.*$', '')
  local is_listed = vim.api.nvim_get_option_value('buflisted', {buf = term.bufnr})
  local status = is_listed and '●' or '○'
  
  return {
    jobid = term.jobid,
    bufnr = term.bufnr,
    pid = term.pid,
    shell = shell,
    status = status,
    display = string.format("%s Job:%d | %s | PID:%d | Buf:%d", 
      status, term.jobid, shell, term.pid, term.bufnr)
  }
end

-- Terminal selector using telescope
function M.select_terminal()
  local terminals = vim.g.slime_last_channel or {}
  
  if #terminals == 0 then
    vim.notify("No terminals found. Open a terminal first with :terminal", vim.log.levels.WARN)
    return
  end

  -- Check if telescope is available
  local ok, telescope = pcall(require, 'telescope')
  if not ok then
    vim.notify("Telescope not available, falling back to vim.ui.select", vim.log.levels.WARN)
    M.select_terminal_fallback()
    return
  end

  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  -- Prepare terminal list with info
  local terminal_list = {}
  for i, term in ipairs(terminals) do
    local info = get_terminal_info(term)
    table.insert(terminal_list, {
      index = i,
      info = info,
      display = info.display
    })
  end

  pickers.new({}, {
    prompt_title = 'Select Slime Terminal Target',
    finder = finders.new_table({
      results = terminal_list,
      entry_maker = function(entry)
        return {
          value = entry.info,
          display = entry.display,
          ordinal = entry.display,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection then
          -- Set slime config to selected terminal and configure it
          vim.g.slime_default_config = { jobid = selection.value.jobid }
          
          -- Automatically call SlimeConfig with the selected job ID
          vim.schedule(function()
            -- Simulate the SlimeConfig input by feeding the job ID
            local jobid = tostring(selection.value.jobid)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
            vim.cmd('SlimeConfig')
            -- Wait a bit then input the job ID
            vim.defer_fn(function()
              vim.api.nvim_feedkeys(jobid .. '\n', 'n', false)
            end, 100)
          end)
          
          vim.notify(string.format("Configuring slime for %s (Job ID: %d)", 
            selection.value.shell, selection.value.jobid), vim.log.levels.INFO)
        end
      end)
      
      -- Additional mapping to jump to terminal buffer
      map('i', '<C-t>', function()
        local selection = action_state.get_selected_entry()
        if selection then
          actions.close(prompt_bufnr)
          vim.api.nvim_set_current_buf(selection.value.bufnr)
        end
      end)
      
      return true
    end,
  }):find()
end

-- Fallback terminal selector using vim.ui.select
function M.select_terminal_fallback()
  local terminals = vim.g.slime_last_channel or {}
  
  if #terminals == 0 then
    vim.notify("No terminals found. Open a terminal first with :terminal", vim.log.levels.WARN)
    return
  end

  local options = {}
  for i, term in ipairs(terminals) do
    local info = get_terminal_info(term)
    table.insert(options, info.display)
  end

  vim.ui.select(options, {
    prompt = 'Select Slime Terminal Target:',
  }, function(choice, idx)
    if choice and idx then
      local selected_term = terminals[idx]
      vim.g.slime_default_config = { jobid = selected_term.jobid }
      local info = get_terminal_info(selected_term)
      
      -- Automatically call SlimeConfig with the selected job ID
      vim.schedule(function()
        local jobid = tostring(selected_term.jobid)
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
        vim.cmd('SlimeConfig')
        -- Wait a bit then input the job ID
        vim.defer_fn(function()
          vim.api.nvim_feedkeys(jobid .. '\n', 'n', false)
        end, 100)
      end)
      
      vim.notify(string.format("Configuring slime for %s (Job ID: %d)", 
        info.shell, selected_term.jobid), vim.log.levels.INFO)
    end
  end)
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
    select_terminal = opts.select_key or '<leader>cT',
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

  vim.keymap.set('n', keymaps.select_terminal, M.select_terminal,
    { desc = '[T] select slime terminal target' })
end

return M
