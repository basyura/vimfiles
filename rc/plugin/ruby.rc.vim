
augroup MyRubyLsp
  autocmd!
  if executable('solargraph')
    " gem install solargraph
    au User lsp_setup call lsp#register_server({
          \ 'name': 'solargraph',
          \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
          \ 'initialization_options': {"diagnostics": "true"},
          \ 'whitelist': ['ruby'],
          \ })

    autocmd FileType ruby call s:configure_lsp()
  endif
augroup END

function! s:configure_lsp() abort
  call Apply_lsp_common_settings()
endfunction
