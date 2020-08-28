
augroup MyRLsp
  autocmd!
  autocmd FileType r call s:configure_lsp()
augroup END

function! s:configure_lsp() abort
  setlocal signcolumn=yes
  setlocal completefunc=lsp#complete
  call Apply_lsp_common_settings()
  inoremap <buffer> -- <- 
  augroup MyRLspAUTO
    autocmd BufWritePre <buffer> LspDocumentFormatSync
  augroup END
endfunction
