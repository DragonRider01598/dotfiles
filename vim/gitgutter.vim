augroup GitGutterColors
  autocmd!
  " Green for added lines
  autocmd ColorScheme,VimEnter * highlight GitGutterAdd guifg=#608B4E ctermfg=71 guibg=NONE ctermbg=NONE
  " Blue for modified lines
  autocmd ColorScheme,VimEnter * highlight GitGutterChange guifg=#569CD6 ctermfg=75 guibg=NONE ctermbg=NONE
  " Red for deleted lines
  autocmd ColorScheme,VimEnter * highlight GitGutterDelete guifg=#D16969 ctermfg=167 guibg=NONE ctermbg=NONE
  " Purple for lines that were changed AND deleted
  autocmd ColorScheme,VimEnter * highlight GitGutterChangeDelete guifg=#C586C0 ctermfg=176 guibg=NONE ctermbg=NONE
augroup END

let g:gitgutter_sign_added = '│'
let g:gitgutter_sign_modified = '│'
let g:gitgutter_sign_removed = '│'

nnoremap <Leader>hc :pclose<CR>
