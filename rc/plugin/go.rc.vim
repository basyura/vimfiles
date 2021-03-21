
if executable('gopls')
  augroup LspGo
    au!
  "   autocmd User lsp_setup call lsp#register_server({
  "       \ 'name': 'go-lang',
  "       \ 'cmd': {server_info->['gopls', '-mode', 'stdio']},
  "       \ 'whitelist': ['go'],
  "       \ })
    autocmd FileType go setlocal omnifunc=lsp#complete
    autocmd FileType go setlocal signcolumn=yes
  augroup END
endif


let go_def_mapping_enabled = 0
let go_doc_keywordprg_enabled = 0
let go_textobj_enabled = 0
let g:lsp_document_code_action_signs_enabled=0
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

  nnoremap <buffer> gi :GoImport 
  nnoremap <buffer> gp :Unite go/import<CR>
  nnoremap <buffer> gb :GoBuild<CR>
  nnoremap <buffer><silent> <C-x><C-b> :call <SID>gobuild()<CR>
  nnoremap <buffer> <C-x><C-i> :GoImport
  nnoremap <buffer> <C-x><C-x> :call <SID>reset_lsp()<CR>


  setlocal tabstop=4
  setlocal shiftwidth=4
  setlocal expandtab
  inoremap <buffer> :: := 
endfunction

function! s:gobuild() 
  let res = system("go build")
  if res == "" 
    let s:timer = timer_start(500, {t ->
          \ execute('echo "build success"', '')},
          \ {'repeat': 1})
  else 
    echo res
  endif
  call s:reset_lsp()
endfunction

function! s:reset_lsp()
  " echo "reset lsp"
  try
    call lsp#stop_server("gopls")
    call timer_start(300, { t -> execute(":edit %")})
  catch 
    echomsg 'error occurred:' . v:exception
  endtry
endfunction
