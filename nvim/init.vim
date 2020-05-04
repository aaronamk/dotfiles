set viminfo+=n~/.config/nvim/viminfo

let g:neotex_enabled=2
"let g:deoplete#enable_at_startup = 1
"let g:ale_complion_enabled = 1

" plugins
call plug#begin('/home/ak/.local/share/nvim/plugged')

"Plug 'vifm/vifm.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'dense-analysis/ale'
Plug 'airblade/vim-gitgutter'
Plug 'donRaphaco/neotex', { 'for': 'tex'}
Plug 'ericcurtin/CurtineIncSw.vim'
"Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()

" plaintext file options
autocmd BufRead *.txt set spell
autocmd BufRead *.txt set lbr

au FocusGained * :checktime

" auto update file when changed from something else
set autoread

set title
set mouse=a
set clipboard=unnamedplus
syntax on
set number

highlight VertSplit cterm=NONE

" file opening completion
set wildmenu
set wildmode=longest,list,full

" use tabs
set tabstop=4
set shiftwidth=4
set list
set listchars=tab:>-

" Delete trailing whitespace
autocmd BufWritePre * %s/\s\+$//e

" mark 80 character limit
set cc=81
hi ColorColumn ctermbg=236

" enable ctrl+delete like other editors
"imap <C-BS> <Esc>bcaw

" screen splitting hotkeys to mirror window manager
set splitbelow splitright
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap <silent> <CR> :noh<CR><CR>

" switch between header and source
map <C-space> :call CurtineIncSw()<CR>


" disable annoying hist file
let g:netrw_dirhistmax = 0
