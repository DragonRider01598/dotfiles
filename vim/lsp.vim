" Combine all LSP options (diagnostics and custom signs) into one clean dictionary
let lspOpts = #{
    \   autoHighlightDiags: v:true,
    \   diagSignErrorText: '✘',
    \   diagSignWarningText: '▲',
    \   diagSignInfoText: '»',
    \   diagSignHintText: '⚑',
    \ }
autocmd User LspSetup call LspOptionsSet(lspOpts)

" Define all language servers
let lspServers = [
      \ #{
      \   name: 'pylsp',
      \   filetype: ['python'],
      \   path: 'pylsp',
      \   args: []
      \ },
      \ #{
      \   name: 'gopls',
      \   filetype: ['go'],
      \   path: 'gopls',
      \   args: []
      \ }
      \ ]

autocmd User LspSetup call LspAddServer(lspServers)

" Key mappings (kept exactly as you had them)
nnoremap gd :LspGotoDefinition<CR>
nnoremap gr :LspShowReferences<CR>
nnoremap K  :LspHover<CR>
nnoremap gl :LspDiag current<CR>
nnoremap <leader>nd :LspDiag next \| LspDiag current<CR>
nnoremap <leader>pd :LspDiag prev \| LspDiag current<CR>
inoremap <silent> <C-Space> <C-x><C-o>

" Set omnifunc for completion across all configured languages
autocmd FileType python,go setlocal omnifunc=lsp#complete
