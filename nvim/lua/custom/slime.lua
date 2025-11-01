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
    type = 'neovim',
    jobid = term.jobid,
    bufnr = term.bufnr,
    pid = term.pid,
    shell = shell,
    status = status,
    display = string.format("%s [NeoVim] Job:%d | %s | PID:%d | Buf:%d", 
      status, term.jobid, shell, term.pid, term.bufnr)
  }
end

-- Function to get tmux pane info
local function get_tmux_panes()
  local handle = io.popen('tmux list-panes -a -F "#{session_name}:#{window_index}.#{pane_index} #{pane_current_command} #{pane_pid} #{pane_current_path}" 2>/dev/null')
  if not handle then return {} end
  
  local panes = {}
  for line in handle:lines() do
    local pane_id, command, pid, path = line:match('([^%s]+)%s+([^%s]+)%s+([^%s]+)%s+(.+)')
    if pane_id and command and pid and path then
      -- Extract session and window info
      local session, window, pane_num = pane_id:match('([^:]+):([^%.]+)%.([^%.]+)')
      local short_path = path:match('([^/]+)$') or path
      
      table.insert(panes, {
        type = 'tmux',
        pane_id = pane_id,
        session = session,
        window = window,
        pane_num = pane_num,
        command = command,
        pid = tonumber(pid),
        path = path,
        display = string.format("● [Tmux] %s | %s | PID:%s | %s", 
          pane_id, command, pid, short_path)
      })
    end
  end
  handle:close()
  return panes
end

-- Function to get all available targets (neovim terminals + tmux panes)
local function get_all_targets()
  local targets = {}
  
  -- Add neovim terminals
  local terminals = vim.g.slime_last_channel or {}
  for _, term in ipairs(terminals) do
    local info = get_terminal_info(term)
    table.insert(targets, info)
  end
  
  -- Add tmux panes
  local tmux_panes = get_tmux_panes()
  for _, pane in ipairs(tmux_panes) do
    table.insert(targets, pane)
  end
  
  return targets
end

-- Terminal selector using telescope
function M.select_terminal()
  local all_targets = get_all_targets()
  
  if #all_targets == 0 then
    vim.notify("No targets found. Open a terminal (:terminal) or tmux pane first", vim.log.levels.WARN)
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

  pickers.new({}, {
    prompt_title = 'Select Slime Target (NeoVim + Tmux)',
    finder = finders.new_table({
      results = all_targets,
      entry_maker = function(target)
        return {
          value = target,
          display = target.display,
          ordinal = target.display,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        
        if selection then
          local target = selection.value
          
          -- Configure based on target type
          if target.type == 'neovim' then
            -- Set slime to neovim mode and configure
            vim.g.slime_target = 'neovim'
            vim.g.slime_default_config = { jobid = target.jobid }
            
            vim.schedule(function()
              local jobid = tostring(target.jobid)
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
              vim.cmd('SlimeConfig')
              vim.defer_fn(function()
                vim.api.nvim_feedkeys(jobid .. '\n', 'n', false)
              end, 100)
            end)
            
            vim.notify(string.format("Configuring slime for NeoVim %s (Job ID: %d)", 
              target.shell, target.jobid), vim.log.levels.INFO)
              
          elseif target.type == 'tmux' then
            -- Set slime to tmux mode and configure
            vim.g.slime_target = 'tmux'
            vim.g.slime_default_config = {
              socket_name = "default",
              target_pane = target.pane_id
            }
            
            vim.schedule(function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
              vim.cmd('SlimeConfig')
              vim.defer_fn(function()
                -- For tmux, input socket name and target pane
                vim.api.nvim_feedkeys('default\n' .. target.pane_id .. '\n', 'n', false)
              end, 100)
            end)
            
            vim.notify(string.format("Configuring slime for Tmux %s (%s)", 
              target.command, target.pane_id), vim.log.levels.INFO)
          end
        end
      end)
      
      -- Additional mapping to jump to terminal buffer (only for neovim)
      map('i', '<C-t>', function()
        local selection = action_state.get_selected_entry()
        if selection and selection.value.type == 'neovim' then
          actions.close(prompt_bufnr)
          vim.api.nvim_set_current_buf(selection.value.bufnr)
        elseif selection and selection.value.type == 'tmux' then
          vim.notify("Use tmux to switch to pane: " .. selection.value.pane_id, vim.log.levels.INFO)
        end
      end)
      
      return true
    end,
  }):find()
end

-- Fallback terminal selector using vim.ui.select
function M.select_terminal_fallback()
  local all_targets = get_all_targets()
  
  if #all_targets == 0 then
    vim.notify("No targets found. Open a terminal (:terminal) or tmux pane first", vim.log.levels.WARN)
    return
  end

  local options = {}
  for _, target in ipairs(all_targets) do
    table.insert(options, target.display)
  end

  vim.ui.select(options, {
    prompt = 'Select Slime Target:',
  }, function(choice, idx)
    if choice and idx then
      local target = all_targets[idx]
      
      -- Configure based on target type
      if target.type == 'neovim' then
        vim.g.slime_target = 'neovim'
        vim.g.slime_default_config = { jobid = target.jobid }
        
        vim.schedule(function()
          local jobid = tostring(target.jobid)
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
          vim.cmd('SlimeConfig')
          vim.defer_fn(function()
            vim.api.nvim_feedkeys(jobid .. '\n', 'n', false)
          end, 100)
        end)
        
        vim.notify(string.format("Configuring slime for NeoVim %s (Job ID: %d)", 
          target.shell, target.jobid), vim.log.levels.INFO)
          
      elseif target.type == 'tmux' then
        vim.g.slime_target = 'tmux'
        vim.g.slime_default_config = {
          socket_name = "default",
          target_pane = target.pane_id
        }
        
        vim.schedule(function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)
          vim.cmd('SlimeConfig')
          vim.defer_fn(function()
            vim.api.nvim_feedkeys('default\n' .. target.pane_id .. '\n', 'n', false)
          end, 100)
        end)
        
        vim.notify(string.format("Configuring slime for Tmux %s (%s)", 
          target.command, target.pane_id), vim.log.levels.INFO)
      end
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

  -- Create the SlimeSelect command
  vim.api.nvim_create_user_command('SlimeSelect', M.select_terminal, {
    desc = 'Select slime terminal target'
  })
end

return M
