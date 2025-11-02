return {
    cmd = { 'R', '--no-echo', '-e', 'languageserver::run()' },
    filetypes = { "r" },
    root_dir = function(fname)
        return vim.fs.root(fname, '.git') or vim.uv.getcwd()
    end,
}
