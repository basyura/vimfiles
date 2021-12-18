
augroup LspVim
  au!
  call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
        \ 'name': 'necovim',
        \ 'allowlist': ['vim'],
        \ 'completor': function('asyncomplete#sources#necovim#completor'),
        \ }))

  autocmd FileType vim  call s:settings()
augroup END

function! s:settings()
  call Apply_lsp_common_settings()
endfunction
