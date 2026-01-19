-- You need to:
-- uv init --script script.py
-- uv add --script script.py 'dependency'
-- uv run script.py
-- For the environment to be created for the script
local function uv_script_interpreter(script_path)
    local result = vim.system(
        { 'uv', 'python', 'find', '--script', script_path },
        { text = true }
    ):wait()
    if result.code == 0 then
        return vim.fn.trim(result.stdout)
    end
end

local function uv_interpreter(script_path)
    local result = vim.system(
        { 'uv', 'python', 'find' },
        { text = true }
    ):wait()
    if result.code == 0 then
        return vim.fn.trim(result.stdout)
    end
end

return {
    cmd = { "ty", "server" },
    filetypes = { "python" },
    root_markers = { "ty.toml", "pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git" },
    settings = { -- settings needs to be initialized for before_init to change it
        ty = {
            configuration = {
                environment = {
                    python = nil,
                },
            },
        },
    },
    before_init = function(_, config)
        local script = vim.api.nvim_buf_get_name(0)
        local python = uv_script_interpreter(script)
        if not python then
            python = uv_interpreter(script)
        end
        config.settings.ty.configuration.environment.python = python
    end,
}
