
let g:go_fmt_autosave = 0

command! GoFmt execute ':VimProcBang goimports -w %' | execute ':edit! %'

augroup MyGroup-go
  autocmd!
  autocmd FileType go  call s:settings()
augroup END

function! s:settings()
  nnoremap gi :GoImports<CR>
  nnoremap gb :GoBuild<CR>
endfunction
