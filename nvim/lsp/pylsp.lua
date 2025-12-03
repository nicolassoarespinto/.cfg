return {
  cmd = { "uvx", "--with", "pylsp-rope", "--with", "pylsp-mypy", "--from", "python-lsp-server[all]", "pylsp" },
  root_markers = { ".git/", "pyproject.toml", "setup.py", "setup.cfg", "uv.lock" },
  filetypes = {'python'},
  settings = {
    pylsp = {
      plugins = {
        isort = {enabled = true},
        rope_import = {
          enabled = true
        },
        jedi = {enabled = true},
        pycodestyle = {
          ignore = { 'W391' },
          maxLineLength = 100
        }
      }
    }
  }
}
