
let g:lsp_preview_doubletap = 0
"let g:lsp_diagnostics_enabled = 0

function! Apply_lsp_common_settings()
  setlocal omnifunc=lsp#complete

  nnoremap <buffer> gd :LspDefinition<CR>
  nnoremap <buffer> <C-k> :LspDefinition<CR>
  nnoremap <buffer> K :LspHover<CR>
  nnoremap <buffer> <Leader>r :LspRename<CR>

  " どこかで上書きされる？
  hi SignColumn guibg=#cccfbf
endfunction
