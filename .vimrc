"""""""""""""""""""""""""""""""""""""""""""""""""""
"  => Plugins
"
""""""""""""""""""""""""""""""""""""""""""""""""""


call plug#begin('~/.vim/plugged')

Plug 'junegunn/vim-easy-align'

Plug 'jpalardy/vim-slime'

Plug 'tranvansang/octave.vim'

Plug 'rafi/awesome-vim-colorschemes'

Plug 'preservim/nerdtree'
call plug#end()


""""""""""""""""""""""""""""""""""""""""""""""""""
"  => General 
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" Sets how many lines of history VIM has to remember
set history=500

"Enable Filetype plugins
filetype plugin on
filetype indent on

" Map leader
let mapleader=","
set nobackup

set nowrap

set noswapfile

""""""""""""""""""""""""""""""""""""""""""""""""""
"  => VIM user interface
"
""""""""""""""""""""""""""""""""""""""""""""""""""

set so=7


set wildmenu
set ruler
set number

set cmdheight=1

""""""""""""""""""""""""""""""""""""""""""""""""""
"  => Colors and Fonts
"
""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
" Colorscheme
"

colorscheme solarized8
set background=dark

" Fix problem of background color on GNU screen
"
"

if &term =~ '256color'
      " disable Background Color Erase (BCE) so that color schemes
      "   " render properly when inside 256-color GNU screen.
    set t_ut=
endif



""""""""""""""""""""""""""""""""""""""""""""""""""
"  => Text, tab and indent
"
""""""""""""""""""""""""""""""""""""""""""""""""""




set expandtab
set smarttab
set tabstop=4
set softtabstop=4
set shiftwidth =4
set autoindent 

set backspace=indent,eol,start

set ruler




""""""""""""""""""""""""""""""""""""""""""""""""""
"  => Mappings
"
""""""""""""""""""""""""""""""""""""""""""""""""""

" Send current paragraph and move down
nmap <F9> <c-c><c-c>}
" Send current line and move down
nmap <F8> ^v$<c-c><c-c><ESC>j

" Circle between tabs
nmap <F6> :tabp<CR>
nmap <F7> :tabn<CR>
nmap <leader>n :tabn<CR>
nmap <leader>p :tabp<CR>


