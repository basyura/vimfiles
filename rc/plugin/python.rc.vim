" https://kashewnuts.github.io/2019/01/28/move_from_jedivim_to_vimlsp.html
augroup MyPythonLsp
  autocmd!
  if executable('pyls')
    autocmd FileType python call s:configure_lsp()
  endif
augroup END

function! s:configure_lsp() abort
  call Apply_lsp_common_settings()
endfunction
