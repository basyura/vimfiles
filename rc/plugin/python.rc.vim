" https://kashewnuts.github.io/2019/01/28/move_from_jedivim_to_vimlsp.html
augroup MyPythonLsp
  autocmd!
  if executable('pyls')
    "autocmd User lsp_setup call lsp#register_server({
        "\ 'name': 'pyls',
        "\ 'cmd': { server_info -> ['pyls'] },
        "\ 'whitelist': ['python']
        "\})
    autocmd FileType python call s:configure_lsp()
  endif
augroup END

function! s:configure_lsp() abort
  setlocal signcolumn=yes
  call Apply_lsp_common_settings()
endfunction
