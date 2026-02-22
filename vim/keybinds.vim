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
