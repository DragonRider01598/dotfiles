let g:netrw_browse_split = 3      " Make netrw open files in a new tab when pressing Enter
let g:netrw_banner = 0            " Hides the bulky help text at the top
let g:netrw_liststyle = 3         " Changes the view to a collapsible file tree
let g:netrw_chgwin = 1            " use existing window if file already open

set undofile                      " Save undo history
set switchbuf=useopen,usetab      " Open tab if file already open

set updatetime=100                " Update git signs quickly
set signcolumn=yes                " Always show the sign column.

set spelllang=en_us               " language for spellings
set complete+=kspell              " use dictonary for autocompletion too
set completeopt=menuone,longest   " give menu for one entry and match to the closest match
set shortmess+=c                  " stop giving info at lightline for completions
