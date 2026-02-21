" === Plugin manager ===
call plug#begin('~/.vim/plugged')

" VSCode Dark+ theme
Plug 'tomasiser/vim-code-dark'

" Status line
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" File explorer + icons
Plug 'preservim/nerdtree'
Plug 'ryanoasis/vim-devicons'

" Git Plugin
Plug 'tpope/vim-fugitive'

" Auto close brackets
Plug 'jiangmiao/auto-pairs'

" Comment toggling
Plug 'tpope/vim-commentary'

call plug#end()

" === General settings ===
set mouse=a
syntax on
set number
set ruler
set cursorline
highlight CursorLine cterm=bold ctermbg=darkgray

set hlsearch
set ignorecase
set smartcase

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent
set showmatch
set wrap
set linebreak

" Enable filetype-based plugins and indentation
filetype plugin indent on

" Remove trailing whitespace from Python on save
autocmd BufWritePre *.py :%s/\s\+$//e

set termguicolors
set background=dark
colorscheme codedark

" Airline theme and Git branch in statusline
let g:airline_theme='codedark'
let g:airline#extensions#branch#enabled = 1
let g:airline_section_c = '%f'               " file path relative to cwd

" NERDTree settings
let NERDTreeShowHidden=1
autocmd FileType nerdtree setlocal norelativenumber
autocmd BufEnter * if winnr('$') == 1 && &filetype ==# 'nerdtree' | quit | endif

" Set Python host
let g:python3_host_prog = '/usr/bin/python3'

" Custom Airline colors
augroup AirlineCustomColors
  autocmd!
  autocmd ColorScheme * call AirlineCustomHighlight()
  autocmd ColorScheme * AirlineRefresh
augroup END

function! AirlineCustomHighlight()
  hi AirlineNormal ctermfg=black ctermbg=white cterm=bold
  hi AirlineInsert ctermfg=black ctermbg=green cterm=bold
  hi AirlineVisual ctermfg=black ctermbg=yellow cterm=bold
  hi AirlineReplace ctermfg=black ctermbg=red cterm=bold

  hi AirlineNormalB ctermfg=white ctermbg=darkgray
  hi AirlineNormalC ctermfg=white ctermbg=black
endfunction

" Cursor shapes per mode (works in many terminals)
if &term =~ 'xterm'
    let &t_SI = "\e[6 q"    " Insert mode: blinking bar
    let &t_EI = "\e[2 q"    " Normal mode: steady block
    let &t_SR = "\e[4 q"    " Replace mode: underline
    autocmd VimLeave * call system('printf "\e[6 q"') " When exiting, reset cursor shape to vertical bar
endif

" NERDTree toggle keymap
nnoremap <C-n> :NERDTreeToggle<CR>
nnoremap <C-a> ggVG"+y

" Clipboard integration
set clipboard=unnamedplus
