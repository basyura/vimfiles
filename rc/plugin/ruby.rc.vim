
"https://github.com/ruby-formatter/rufo-vim
"https://qiita.com/tackeyy/items/0710a424d5b4b14ca0d9
"let g:rufo_auto_formatting = 1
"
augroup MyRubyLsp
 autocmd!
 if executable('solargraph')
   autocmd FileType ruby call s:configure_lsp()
 endif
augroup END

function! s:configure_lsp() abort
 call Apply_lsp_common_settings()
endfunction
