
augroup MyRLsp
  autocmd!
  autocmd FileType r call s:configure_lsp()
augroup END

function! s:configure_lsp() abort
  inoremap <buffer> -- <- 
  augroup MyRLspAUTO
    autocmd BufWritePre <buffer> LspDocumentFormatSync
  augroup END
endfunction
