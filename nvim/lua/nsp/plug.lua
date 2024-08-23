local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('junegunn/seoul256.vim')
Plug('junegunn/vim-easy-align')
Plug('rafi/awesome-vim-colorschemes')
Plug('preservim/nerdtree')
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug('BurntSushi/ripgrep')
Plug('nvim-treesitter/nvim-treesitter')
Plug('theprimeagen/harpoon')
Plug('mbbill/undotree')
Plug('tpope/vim-fugitive')
vim.call('plug#end')

