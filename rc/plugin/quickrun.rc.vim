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
  let g:quickrun_config.json = {
    \ 'outputter/buffer/filetype': 'json',
    \ 'command': 'jq',
    \ 'cmdopt': '.',
    \ 'exec': 'cat %s | %c %o',
    \ }
"  let g:quickrun_config['cs'] = {
"        \ 'command' : 'dmcs',
"        \ 'runmode' : 'simple',
"        \ 'exec' : ['%c %s > /dev/null', 'mono "%S:p:r:gs?/?\\?.exe" %a', ':call delete("%S:p:r.exe")'],
"        \ 'tempfile' : '%{tempname()}.cs',
"        \ }

 let g:quickrun_config['cs'] = {
    \   'exec': ['%c %o -out:%s:p:r.exe %s', 'mono %s:p:r.exe %a'],
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


let g:quickrun_config.go = {
      \   'command': 'go',
      \   'exec': '%c run *.go %a',
      \   'tempfile': '%{tempname()}.go',
      \   'hook/output_encode/encoding': 'utf-8',
      \   'hook/cd/directory': '%S:p:h',
      \ }

"https://yanor.net/wiki/?Vim/%E3%83%97%E3%83%A9%E3%82%B0%E3%82%A4%E3%83%B3/vim-quickrun/TypeScript%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%82%92%E5%A4%89%E6%9B%B4
let g:quickrun_config['typescript'] = { 'type' : 'typescript/tsc' }
let g:quickrun_config['typescript/tsc'] = {
\   'command': 'tsc',
\   'exec': ['%c --target es5 --module commonjs --lib dom,es2015 %o %s', 'node %s:r.js'],
\   'tempfile': '%{tempname()}.ts',
\   'hook/sweep/files': ['%S:p:r.js'],
\ }



let g:quickrun_config['r'] =  {
\   'command': 'R',
\   'exec': '%c %o --no-save --slave %a < %s',
\   'hook/open': 'Rplots.pdf',
\ }

