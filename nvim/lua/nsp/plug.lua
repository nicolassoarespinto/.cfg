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
Plug('jpalardy/vim-slime')

Plug('sudormrfbin/cheatsheet.nvim')
Plug('ThePrimeagen/vim-be-good')

-- LSP --

Plug('williamboman/mason.nvim')
Plug('neovim/nvim-lspconfig')
Plug('williamboman/mason-lspconfig.nvim')

-- Autocompletion --
Plug('hrsh7th/nvim-cmp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-nvim-lua')

-- Snippets --
Plug('saadparwaiz1/cmp_luasnip')


-- Copilot --
Plug('github/copilot.vim')

-- 
--
vim.call('plug#end')

