return {
    cmd = { "uvx", "--with", "pylsp-rope", "--with", "pylsp-mypy", "--from", "python-lsp-server[all]", "pylsp" },
    root_markers = { ".venv" },
    filetypes = { 'python' },
    settings = {
        pylsp = {
            plugins = {
                isort = { enabled = true },
                rope_import = {
                    enabled = true
                },
                jedi = { enabled = true, environment = "./.venv/bin/python3" },
                pycodestyle = {
                    ignore = { 'W391' },
                    maxLineLength = 100
                }
            }
        }
    }
}
