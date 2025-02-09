return { 
    "github/copilot.vim",
    name = "copilot",
    config = function ()
        vim.keymap.set('n', '<leader>cp', ':Copilot panel<CR>', {})
        vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<CR>")', {
          expr = true,
          replace_keycodes = false
        })
        vim.g.copilot_no_tab_map = true

    end

}
