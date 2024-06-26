
let go_def_mapping_enabled = 0
let go_doc_keywordprg_enabled = 0
let go_textobj_enabled = 0
let g:lsp_document_code_action_signs_enabled=0
let g:goimports = 0

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
  autocmd! BufWritePre *.go call execute('LspDocumentFormatSync')
  nnoremap <buffer> gi :GoImportRun<CR>
  nnoremap <buffer> gp :Unite go/import<CR>
  nnoremap <buffer> gb :GoBuild<CR>
  nnoremap <buffer><silent> <C-x><C-b> :call <SID>gobuild()<CR>
  nnoremap <buffer> <C-x><C-i> :GoImport
  " nnoremap <buffer> <C-x><C-x> :call <SID>reset_lsp()<CR>

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
  " call s:reset_lsp()
  :ResetLsp
endfunction

" function! s:reset_lsp()
"   " echo "reset lsp"
"   try
"     call lsp#stop_server("gopls")
"     call timer_start(300, { t -> execute(":edit %")})
"   catch 
"     echomsg 'error occurred:' . v:exception
"   endtry
" endfunction
