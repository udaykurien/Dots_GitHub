" Install vim plugin manager for plugins:
" curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

" Set a global variable to show python environment so nvim doesnt crash in
" virtual enviornments
let g:python3_host_prog = '/usr/bin/python3'

" Assign a clipboard to nvim
" apt install wl-clipboard
set clipboard=unnamedplus

call plug#begin('~/.local/share/nvim/site/plugged')
" Plugin Section
 Plug 'ryanoasis/vim-devicons'
" Plug 'SirVer/ultisnips'
 Plug 'honza/vim-snippets'
 Plug 'scrooloose/nerdtree'
 Plug 'preservim/nerdcommenter'
 Plug 'mhinz/vim-startify'
 Plug 'neoclide/coc.nvim', {'branch': 'release'}

 " Themes
 Plug 'Shatur/neovim-ayu'
 Plug 'rose-pine/neovim', { 'as': 'rose-pine' }
 Plug 'Mofiqul/vscode.nvim'
 Plug 'navarasu/onedark.nvim'
 Plug 'rebelot/kanagawa.nvim'
 Plug 'dracula/vim'
 Plug 'morhetz/gruvbox'
 Plug 'luisiacc/gruvbox-baby'
 Plug 'sainnhe/gruvbox-material'
 Plug 'folke/tokyonight.nvim'
 Plug 'catppuccin/nvim', { 'as': 'catppuccin' }
 Plug 'joshdick/onedark.vim'
 Plug 'arcticicestudio/nord-vim'
call plug#end()


set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=4               " number of columns occupied by a tab 
set softtabstop=4           " see multiple spaces as tabstops so <BS> does the right thing
set expandtab               " converts tabs to white space
set shiftwidth=4            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers
set wildmode=longest,list   " get bash-like tab completions
" set cc=80                  " set an 80 column border for good coding style
filetype plugin indent on   "allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set cursorcolumn            " highlight current cursorcolumn
set ttyfast                 " Speed up scrolling in Vim
" set spell                 " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.
"colorscheme ayu-dark         " Set colorscheme
"lua << EOF
"require('onedark').setup({
"    style = 'darker'
"})
"require('onedark').load()
"EOF

" Keybindings
" Open/close nerdtree file explorer
nnoremap <C-n> :NERDTreeToggle<CR>
