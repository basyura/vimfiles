
if exists('RmVimball')
  delcommand RmVimball
endif

" change to newspaper colorscheme
command! NewsPaper call s:newspaper()
function! s:newspaper()
  let g:my_color_scheme = 'newspaper'
  source $MYGVIMRC
endfunction

command! Desert call s:desert()
function! s:desert()
  let g:my_color_scheme = 'desert'
  source $MYGVIMRC
endfunction

command! Wombat call s:wombat()
function! s:wombat()
  let g:my_color_scheme = 'wombat'
  source $MYGVIMRC
endfunction


" rails
command! RailsMode call s:rails_mode()
function! s:rails_mode()
  nnoremap <C-p> :Unite rails/
endfunction

" indent xml
command! IndentXML call s:indent_xml()
function! s:indent_xml()
  let xml = util#xml#indent(join(getline(1,'$'),"\n"))
  silent %delete _
  set paste
  execute 'normal i' . xml
  set nopaste
  :0
endfunction
" xpath
command! -nargs=1 XPath let @" = util#xml#xpath_text(join(getline(1,'$'),"\n") , <f-args>) | echo @"

command! MoveLeft call s:MoveLeft()
function! s:MoveLeft()
  winpos 0 0
  set lines=999
endfunction

command! CloseAll call s:close_all() "{{{
function! s:close_all()
  let l:bufnr = 1
  while l:bufnr <= bufnr('$')
    if buflisted(l:bufnr) && bufname(l:bufnr) !~ "vimshell"
      exec "bd! " . l:bufnr
    endif
    let l:bufnr += 1
  endwhile
endfunction "}}}

command! WriteToFile call s:write_to_file() " {{{
function! s:write_to_file()
  if &filetype == 'yarm'
    echo 'please use :w'
    return
  end
  try
    silent w
    let msg = ' write to ' . bufname('%') . ' ... OK !!! '
    echohl CursorLine| echo msg | echohl None
  endtry
endfunction "}}}

command! GoFmt execute ':VimProcBang gofmt -w %' | execute ':edit! %'

command! TabNew :call s:tabnew() "{{{
function! s:tabnew()
  tabnew
  Scratch
  wincmd p
  bd
endfunction "}}}

" ■ proxy
function! s:off_proxy()
  let $http_proxy  = ""
  let $https_proxy = ""
  let $HTTP_PROXY  = ""
  let $HTTPS_PROXY = ""
endfunction
command! OffProxy call <SID>off_proxy()

nnoremap <Space>full :call FullScreen()<Enter>
function! FullScreen()
  set columns=195
  set lines=43
endfunction

" カーソル位置の highlight グループを取得する．
command! -nargs=0 GetHighlightingGroup echo 'hi<' . synIDattr(synID(line('.'),col('.'),1),'name') . '> trans<' . synIDattr(synID(line('.'),col('.'),0),'name') . '> lo<' . synIDattr(synIDtrans(synID(line('.'),col('.'),1)),'name') . '>'

command! -nargs=? -complete=dir -bang CD  call s:ChangeCurrentDir('<args>', '<bang>')
function! s:ChangeCurrentDir(directory, bang)

  if &filetype == 'vimfiler'
    lcd `=b:vimfiler.current_dir`
    return
  endif

  if a:directory == ''
    lcd %:p:h
  else
    execute 'lcd' . a:directory
  endif

  if a:bang == ''
    pwd
  endif
endfunction
