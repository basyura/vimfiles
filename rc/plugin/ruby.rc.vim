
"https://github.com/ruby-formatter/rufo-vim
"https://qiita.com/tackeyy/items/0710a424d5b4b14ca0d9
"let g:rufo_auto_formatting = 1
"
augroup MyRubyLsp
 autocmd!
 if executable('solargraph')
   " gem install solargraph
   au User lsp_setup call lsp#register_server({
         \ 'name': 'solargraph',
         \ 'cmd': {server_info->[&shell, &shellcmdflag, 'solargraph stdio']},
         \ 'whitelist': ['ruby'],
         \ })

"          \ 'initialization_options': {"diagnostics": "true"},

   autocmd FileType ruby call s:configure_lsp()
 endif
augroup END

function! s:configure_lsp() abort
 call Apply_lsp_common_settings()
endfunction
