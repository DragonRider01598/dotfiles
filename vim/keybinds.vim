" Set leader key
let mapleader = " "

" Open netrw with <leader>cd
function! NetrwFocus()
    if getbufvar(tabpagebuflist(1)[0], '&filetype') ==# 'netrw'
        execute 'tabnext 1'
        execute '1wincmd w'
    else
        execute '0tabedit .'
    endif
endfunction
nnoremap <leader>cd :call NetrwFocus()<CR>

" Switch tabs
nnoremap <Tab> :tabnext<CR>
nnoremap <S-Tab> :tabprevious<CR>

" Navigate the complete menu items like CTRL+n / CTRL+p would.
inoremap <expr> <Down> pumvisible() ? "<C-n>" :"<Down>"
inoremap <expr> <Up> pumvisible() ? "<C-p>" : "<Up>"

" Select the complete menu item like CTRL+y would.
inoremap <expr> <Right> pumvisible() ? "<C-y>" : "<Right>"
inoremap <expr> <CR> pumvisible() ? "<C-y>" :"<CR>"

" Cancel the complete menu item like CTRL+e would.
inoremap <expr> <Left> pumvisible() ? "<C-e>" : "<Left>" 
