
" 1 が設定されていれば有効になる
"let g:enable_highlight_cursor_word = 0
let g:enable_highlight_cursor_word = 0

augroup highlight-cursor-word
    autocmd!
    "autocmd CursorHold  * call s:hl_cword()
    autocmd InsertLeave * call s:hl_cword()
    " カーソル移動が重くなったと感じるようであれば
    " CursorMoved ではなくて
    " CursorHold を使用する
"     autocmd CursorHold * call s:hl_cword()
    " 単語のハイライト設定
    autocmd ColorScheme * highlight CursorWord guibg=#dcdda8
    "autocmd ColorScheme * highlight CursorWord guifg=#0f58af 
    " アンダーラインでハイライトを行う場合
    " autocmd ColorScheme * highlight CursorWord gui=underline guifg=NONE
    autocmd BufLeave    * call s:hl_clear()
    autocmd WinLeave    * call s:hl_clear()
    autocmd InsertEnter * call s:hl_clear()
augroup END


function! s:hl_clear()
    if exists("b:highlight_cursor_word_id") && exists("b:highlight_cursor_word")
        silent! call matchdelete(b:highlight_cursor_word_id)
        unlet b:highlight_cursor_word_id
        unlet b:highlight_cursor_word
    endif
endfunction

function! s:hl_cword()
  if &filetype == 'unite'
    return
  endif
  let word = expand("<cword>")
  if word == "" || word =~ '^if$\|^end$\|^else$\|^endif$\|^get$\|^unlet$\|^let$\|return\|call\|filter\|split\|function\|autocmd\|augroup\|empty\|expand\|silent\|^for$\|endfor'
    return
  endif
  if get(b:, "highlight_cursor_word", "") ==# word
    return
  endif

  call s:hl_clear()
  if !g:enable_highlight_cursor_word
    return
  endif

  if !empty(filter(split(word, '\zs'), "strlen(v:val) > 1"))
    return
  endif

  let pattern = printf("\\<%s\\>", expand("<cword>"))
  silent! let b:highlight_cursor_word_id = matchadd("CursorWord", pattern)
  let b:highlight_cursor_word = word
endfunction
