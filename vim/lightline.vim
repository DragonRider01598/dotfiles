set laststatus=2
set showtabline=2
set noshowmode

if has('termguicolors')
  set termguicolors
endif

let g:lightline = {
      \ 'colorscheme': 'codedark',
      \
      \ 'separator': { 'left': '', 'right': '' },
      \ 'subseparator': { 'left': '', 'right': '' },
      \
      \ 'active': {
      \   'left': [
      \     [ 'mode' ],
      \     [ 'branch' ],
      \     [ 'filename', 'modified' ]
      \   ],
      \   'right': [
      \     [ 'lineinfo' ],
      \     [ 'percent' ],
      \     [ 'filetype' ]
      \   ]
      \ },
      \ 'tabline': {
      \     'left': [ [ 'tabs' ] ],
      \     'right': [ [ 'clocktime' ] ]
      \ },
      \
      \ 'component_function': {
      \   'branch': 'LightlineBranch',
      \   'filename': 'LightlineFilename',
      \   'clocktime': 'LightlineClockTime',
      \ }
      \ }

function! LightlineFilename()
  let l = expand('%:~:.')
  if empty(l)
    return ''
  endif
  return strlen(l) > 40 ? '…' . l[-37:] : l
endfunction

function! LightlineBranch()
  if exists('*FugitiveHead')
    let l:branch = FugitiveHead()
    return empty(l:branch) ? '' : ' ' . l:branch
  endif
  return ''
endfunction

function! LightlineClockTime()
  return strftime('%d %b %H:%M')
endfunction

if exists('*timer_start')
  function! LightlineUpdateClock(timer)
    call lightline#update()
  endfunction
  call timer_start(60000, 'LightlineUpdateClock', {'repeat': -1})
endif

augroup LightlineCustomColors
  autocmd!
  autocmd ColorScheme,VimEnter * call s:PatchLightlineClock()
augroup END

function! s:PatchLightlineClock() abort
  try
    let l:palette = g:lightline#colorscheme#codedark#palette
    let l:palette.tabline.right = [ [ '#30a4f2', '#1E1E1E', 230, 59 ] ]
    call lightline#colorscheme()
    call lightline#update()
  catch
  endtry
endfunction
