" --- Core usability ---
set mouse=a
syntax on
set number
set relativenumber
set cursorline
set showcmd
set showmatch

set backspace=indent,eol,start

" --- Disable wrapping ---
set formatoptions-=cro

" --- Bell Behaviour ---
set noerrorbells

" --- Splits ---
set splitbelow
set splitright

" --- Searching ---
set incsearch
set hlsearch
set ignorecase
set smartcase

" --- Indentation ---
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent

" --- Filetype detection ---
filetype plugin indent on

" --- Clipboard (safe on modern systems) ---
set clipboard=unnamedplus

" --- True color support ---
set termguicolors
set background=dark
colorscheme wildcharm

" --- Cursor shapes (terminal only) ---
if &term =~ 'xterm'
  let &t_SI = "\e[6 q"
  let &t_EI = "\e[2 q"
  let &t_SR = "\e[4 q"
  autocmd VimLeave * silent! call system('printf "\e[6 q"')
endif
