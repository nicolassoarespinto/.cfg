
return {

    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
        "tpope/vim-dadbod",
        "kristijanhusak/vim-dadbod-completion",
    },
    config = function() 
        vim.keymap.set('n', '<leader>db', ':DBUIToggle<CR>', { desc = 'Toggle DADBOD UI' })
        vim.keymap.set('n', '<leader>dbw', '<Plug>DBUI_SaveQuery<CR>', { desc = 'Save query' })
        vim.keymap.set('n', '<leader>dbr', '<Plug>DBUI_ToggleResultLayout<CR>', { desc = 'Toggle result layout' })
        require "custom.dbui"

    end
    
}


