
let g:lsp_preview_doubletap = 0
"let g:lsp_diagnostics_enabled = 0

" メソッドのコメントを補完時にポップアップ表示する
let g:lsp_documentation_float=0

function! Apply_lsp_common_settings()
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

  nnoremap <buffer> gd :LspDefinition<CR>
  nnoremap <buffer> <C-k> :LspDefinition<CR>
  nnoremap <buffer> K :LspHover<CR>
  nnoremap <buffer> <Leader>r :LspRename<CR>
  nnoremap <buffer> <C-x><C-f> :LspDocumentFormat<CR>
  nnoremap <buffer> <C-x><C-d> :LspDocumentDiagnostic<CR>
  nnoremap <buffer> <C-x><C-l> :LspNextError<CR>

  " どこかで上書きされる？
  if g:colors_name == "newspaper"
    hi SignColumn guibg=#cccfbf
  else
    hi SignColumn guibg=black
  endif
endfunction

augroup LspCommonGroup
  autocmd FileType vue  call Apply_lsp_common_settings()
augroup END
