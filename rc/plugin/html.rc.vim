
augroup MyHtmlLsp
  autocmd!
  autocmd FileType html call s:configure_lsp()
augroup END

function! s:configure_lsp() abort
  call Apply_lsp_common_settings()
endfunction
