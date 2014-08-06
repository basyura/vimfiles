" quickrun
"
"
silent! nmap <Leader>q :call <SID>_quickrun()<CR>

function! s:_quickrun()
  set noshellslash 
  :QuickRun
  set shellslash
endfunction

augroup mygroup-quickrun
  autocmd!
  autocmd FileType quickrun    call s:quickrun_setting()
augroup END

function! s:quickrun_setting()
  nmap <buffer> <C-j> :bd!<CR>
endfunction

if has('mac')
  let g:quickrun_config = {
        \ '*' : {'into' : 0},
        \ 'uiki': {
        \   'exec'      : 'ucloth %s',
        \   'outputter' : 'browser'  ,
        \ },
        \}
"  let g:quickrun_config['cs'] = {
"        \ 'command' : 'dmcs',
"        \ 'runmode' : 'simple',
"        \ 'exec' : ['%c %s > /dev/null', 'mono "%S:p:r:gs?/?\\?.exe" %a', ':call delete("%S:p:r.exe")'],
"        \ 'tempfile' : '%{tempname()}.cs',
"        \ }

 let g:quickrun_config['cs'] = {
    \   'exec': ['%c -sdk:4.5 %o -out:%s:p:r.exe %s', 'mono %s:p:r.exe %a'],
    \ }
else
  let g:quickrun_config = {
        \ '*' : {'into' : 0},
        \ 'uiki': {
        \   'exec'      : 'ucloth %s',
        \   'outputter' : 'browser'  ,
        \   'region' : {
        \     'first': [1, 0, 0],
        \     'last' :  [line('$'), 0, 0],
        \     'wise' : 'V',
        \    },
        \ },
        \}
"  let g:quickrun_config['cs'] = {
"        \ 'command' : 'csc',
"        \ 'runmode' : 'simple',
"        \ 'output_encode' : 'cp932:utf-8',
"        \ 'exec' : ['%c /nologo /reference:System.dll %s:gs?/?\\? > /dev/null', '"%S:p:r:gs?/?\\?.exe" %a', ':call delete("%S:p:r.exe")'],
"        \ 'tempfile' : '{tempname()}.cs',
"        \ }
endif

let g:quickrun_config.markdown = {
      \ 'exec'      : 'kramdown %s',
      \ 'outputter' : 'browser',
      \ }


if has('win32')
  let g:quickrun_config['java'] = {
        \ 'output_encode' : 'cp932:utf-8',
        \ }
endif

