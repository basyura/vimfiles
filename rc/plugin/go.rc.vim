
if executable('gopls')
  augroup LspGo
    au!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'go-lang',
        \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
        \ 'whitelist': ['go'],
        \ })
    autocmd FileType go setlocal omnifunc=lsp#complete
    autocmd FileType go setlocal signcolumn=yes
  augroup END
endif

let go_def_mapping_enabled = 0
let go_doc_keywordprg_enabled = 0
let go_textobj_enabled = 0
"let g:go_fmt_autosave = 0
"let g:go_gocode_unimported_packages = 1

command! GoFmt call s:gofmt()

function! s:gofmt()
  :w
  execute ':VimProcBang goimports -w %' | execute ':edit! %'
endfunction


augroup MyGroup-go
  autocmd!
  autocmd FileType go  call s:settings()
augroup END

function! s:settings()
  call Apply_lsp_common_settings()

  nnoremap <buffer> gi :GoImports<CR>
  nnoremap <buffer> gp :Unite go/import<CR>
  nnoremap <buffer> gb :GoBuild<CR>
  nnoremap <buffer> <C-x><C-b> :GoBuild<CR>
  nnoremap <buffer> <C-x><C-i> :GoImports<CR>
endfunction
