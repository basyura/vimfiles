
if executable('typescript-language-server')
  augroup LspTypeScript
    au!
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact  call s:settings()
  augroup END
endif

function! s:settings()
  call Apply_lsp_common_settings()
endfunction
