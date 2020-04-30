set viminfo+=n~/.config/nvim/viminfo

let g:neotex_enabled=2
"let g:deoplete#enable_at_startup = 1
"let g:ale_complion_enabled = 1

" plugins
call plug#begin('/home/ak/.local/share/nvim/plugged')

Plug 'jiangmiao/auto-pairs'
Plug 'donRaphaco/neotex', { 'for': 'tex'}
Plug 'dense-analysis/ale'
Plug 'ericcurtin/CurtineIncSw.vim'
Plug 'airblade/vim-gitgutter'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

" auto update file when changed from something else
set autoread

au FocusGained * :checktime
set title

set mouse=a
set number
syntax on
set wildmode=longest,list,full

set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-

set cc=81
hi ColorColumn ctermbg=236

set splitbelow splitright
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap <silent> <CR> :noh<CR><CR>

map <C-space> :call CurtineIncSw()<CR>

set clipboard=unnamedplus

let g:netrw_dirhistmax = 0

" Delete trailing whitespace
autocmd BufWritePre * %s/\s\+$//e
