
if exists('RmVimball')
  delcommand RmVimball
endif

command! PutMessage call s:put_message()
function! s:put_message()
  :enew
  :put =execute('messages')
  :setf vim
endfunction

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
  set lines=999
  winpos -7 0
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

command! TabNew :call s:tabnew() "{{{
function! s:tabnew()
  tabnew
  " Scratch
  " wincmd p
  " bd
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



function! s:UrlEncode(str, ...) abort
  " 追加で残す文字（例：'/' を残したい場合は keep='-._~/'）を第 2 引数で指定可能
  let keep = (a:0 >= 1 ? a:1 : '-._~')

  let out = []
  " 文字単位で処理（文字列を 1 文字ずつのリストに分解）
  for ch in split(a:str, '\zs')
    if ch =~# '^[A-Za-z0-9' . escape(keep, ']-') . ']\+$'
      " 許可文字はそのまま
      call add(out, ch)
    else
      " UTF-8 に変換してバイト列を %HH に
      let utf = iconv(ch, &encoding, 'utf-8')
      " 文字列はバイトインデックスでアクセスできる
      for i in range(0, strlen(utf) - 1)
        let b = char2nr(utf[i])
        call add(out, printf('%%%02X', b))
      endfor
    endif
  endfor

  return join(out, '')
endfunction

function! s:UrlEncodeClipboard(...) abort
  " クリップボードから取得
  let s = getreg('+')

  if empty(s)
    echo "Clipboard is empty."
    return
  endif

  " 第 1 引数に追加で残したい文字を渡せる（例：'/')
  let keep = (a:0 >= 1 ? a:1 : '-._~')

  let encoded = s:UrlEncode(s, keep)

  " クリップボードへ書き戻し
  call setreg('+', encoded)

  echo "URL-encoded to clipboard."
endfunction


command! UrlEncode call s:UrlEncodeClipboard()
