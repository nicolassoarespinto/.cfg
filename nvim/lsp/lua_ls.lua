return {
    capabilities = {
        semanticTokensProvider = vim.NIL,
    },

    settings = {
        Lua = {
            diagnostics = {
                enable = true,
                unusedLocalExclude = {
                    "_*",
                },
                globals = { "vim" },
            },
            completion = {
                autoRequire = true,
                callSnippet = "Disable",
                displayContext = 2,
            },
            format = {
                enable=true
            },
            hint = {
                enable = true,
                setType = true,
                arrayIndex = "Disable",
                await = true,
                paramName = "All",
                paramType = true,
                semicolon = "SameLine",
            },
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
        },
    },
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
    root_markers = {
        ".luarc.json",
        "luarc.json",
        ".git",
    },
}
