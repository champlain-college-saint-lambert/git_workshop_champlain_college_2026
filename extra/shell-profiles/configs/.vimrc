" Git Workshop Vim Configuration
" Simple but effective setup for Git commit messages and file editing

" Basic settings
set nocompatible
syntax on
set number
set relativenumber
set ruler
set showcmd
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set backspace=indent,eol,start
set autoindent
set smartindent
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set wrap
set linebreak
set scrolloff=3
set sidescrolloff=5

" Visual settings
set background=dark
colorscheme default
set laststatus=2
set statusline=%f\ %h%w%m%r\ %=%(%l,%c%V\ %=\ %P%)

" Git commit message settings
autocmd FileType gitcommit setlocal spell
autocmd FileType gitcommit setlocal textwidth=72
autocmd FileType gitcommit setlocal colorcolumn=50,72

" File type specific settings
autocmd FileType markdown setlocal wrap linebreak nolist textwidth=0 wrapmargin=0
autocmd FileType text setlocal wrap linebreak nolist textwidth=0 wrapmargin=0

" Key mappings
nnoremap <C-L> :nohl<CR><C-L>
nnoremap Y y$
nnoremap n nzzzv
nnoremap N Nzzzv

" Insert mode mappings
inoremap jk <ESC>
inoremap kj <ESC>

" Visual mode mappings
vnoremap < <gv
vnoremap > >gv

" Leader key mappings
let mapleader = " "
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>x :x<CR>

" Git-specific shortcuts for commit messages
autocmd FileType gitcommit nnoremap <buffer> <leader>s i[skip ci]<ESC>
autocmd FileType gitcommit nnoremap <buffer> <leader>f ifix: <ESC>A
autocmd FileType gitcommit nnoremap <buffer> <leader>a iadd: <ESC>A
autocmd FileType gitcommit nnoremap <buffer> <leader>u iupdate: <ESC>A
autocmd FileType gitcommit nnoremap <buffer> <leader>r irefactor: <ESC>A

" Enable mouse support
if has('mouse')
    set mouse=a
endif

" Persistent undo
if has('persistent_undo')
    set undodir=~/.vim/undo
    set undofile
    set undolevels=1000
    set undoreload=10000
endif

" Auto-create directories
if !isdirectory($HOME.'/.vim/undo')
    call mkdir($HOME.'/.vim/undo', 'p')
endif

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Git workshop specific templates
autocmd BufNewFile,BufRead COMMIT_EDITMSG setlocal filetype=gitcommit
autocmd FileType gitcommit 0r ~/.vim/templates/gitcommit.txt

" Create template directory and file
if !isdirectory($HOME.'/.vim/templates')
    call mkdir($HOME.'/.vim/templates', 'p')
endif

" Simple completion
set wildmenu
set wildmode=list:longest,full

" Buffer management
nnoremap <leader>bn :bnext<CR>
nnoremap <leader>bp :bprevious<CR>
nnoremap <leader>bd :bdelete<CR>

" Window management
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Git workshop help
command! GitWorkshopHelp echo "Git Workshop Vim Commands:\n<leader>s - Add [skip ci]\n<leader>f - Start with 'fix:'\n<leader>a - Start with 'add:'\n<leader>u - Start with 'update:'\n<leader>r - Start with 'refactor:'"
