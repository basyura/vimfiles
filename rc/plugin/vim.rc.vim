
augroup LspVim
  au!
  autocmd FileType vim  call s:settings()
augroup END

function! s:settings()
  call Apply_lsp_common_settings()
endfunction
