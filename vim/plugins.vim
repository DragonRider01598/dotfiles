let s:plugin_dir = expand('~/.vim/plugged')

function! s:ensure(repo)
  let name = split(a:repo, '/')[-1]
  let path = s:plugin_dir . '/' . name

  if !isdirectory(path)
    if !isdirectory(s:plugin_dir)
      call mkdir(s:plugin_dir, 'p')
    endif
    execute '!git clone --depth=1 https://github.com/' . a:repo . ' ' . shellescape(path)
  endif

  execute 'set runtimepath+=' . fnameescape(path)
endfunction

command! UpdatePlugins call s:update_plugins()

function! s:update_plugins()
  echo "Pulling updates for all plugins..."

  for dir in glob(s:plugin_dir . '/*', 1, 1)
    if isdirectory(dir . '/.git')
      let name = fnamemodify(dir, ':t')
      echo "Updating " . name . "..."
      execute 'silent !git -C ' . shellescape(dir) . ' pull --quiet --ff-only'
    endif
  endfor

  redraw!
  echo "All plugins updated successfully!"
endfunction

call s:ensure('tomasiser/vim-code-dark')
call s:ensure('junegunn/fzf')
call s:ensure('junegunn/fzf.vim')
call s:ensure('itchyny/lightline.vim')
call s:ensure('tpope/vim-fugitive')
call s:ensure('yegappan/lsp')
call s:ensure('airblade/vim-gitgutter')
