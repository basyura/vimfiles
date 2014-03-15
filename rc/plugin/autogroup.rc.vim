""""""""""""""""""""""""""""""""""
"         auto command           "
""""""""""""""""""""""""""""""""""
augroup MyGroup
  autocmd!
  au BufWritePost * call s:delete_history()
  au BufDelete * call s:delete_history()
  au BufNewFile,BufRead *.scala setf scala
  "set autochdir
  au BufEnter * call s:all_bufenter_setting()

  autocmd FileType ruby,eruby,scala,javascript  :setlocal tabstop=2
  autocmd FileType ruby,eruby,scala,javascript  :setlocal shiftwidth=2
  autocmd FileType ruby,eruby,scala,javascript  :setlocal expandtab

  autocmd FileType java,c,cpp,cs :setlocal tabstop=4
  autocmd FileType java,c,cpp,cs :setlocal shiftwidth=4
  autocmd FileType java,c,cpp,cs :setlocal noexpandtab

  autocmd FileType help :setlocal noexpandtab

  autocmd BufRead,BufNewFile *.mkd  set filetype=markdown
  autocmd BufRead,BufNewFile *.md   set filetype=markdown
  " for uiki
  autocmd FileType uiki nnoremap <buffer> mq ggvG$:QuickRun<CR>

  autocmd BufRead,BufNewFile *.ecob set filetype=cobol

  autocmd FileType netrw setlocal buftype=nofile bufhidden=delete

  autocmd FileType scratch      call s:scratch_my_settings()

  autocmd FileType note       call s:note_settings()

  autocmd FileType git :setlocal foldlevel=99

  autocmd FileType svn :setlocal noswapfile

  autocmd BufRead,BufNewFile *.ex,*.exs set filetype=elixir

  if !has('gui_running')
    autocmd InsertEnter,InsertLeave * set cursorline!
  endif
augroup END

function! s:delete_history()
  "call histdel(":", 'w\|bd\|WQ\|Scratch\|q\|ls\|close')
  call histdel(":", '^Kwbd$\|^history$\|^wq$\|^bd$\|^w$\|^enew$\|^q$')
endfunction

function! s:note_settings()
  nnoremap <silent> <buffer> <C-l> :Unite outline -vertical -winwidth=50 -no-quit -no-start-insert -buffer-name=outline -hide-source-names -direction=rightbelow<CR>
endfunction


function! s:bg_settings()
  AlterCommand <buffer> q bd
endfunction

function! s:all_bufenter_setting()
  setlocal bufhidden=hide
  if &filetype == ''
    if expand("%") =~ '\[quickrun output\]'
      setfiletype quickrun
    else
      setfiletype txt
    endif
  endif

  if &modifiable && join(getline(1,3)) == ''
    setlocal fileencoding=utf-8
    setlocal fileformat=unix
    setlocal nomodified
  endif

  try
    execute ":lcd " . substitute(expand("%:p:h")," ",'\\ ','g')
  catch
  endtry
endfunction

function! s:scratch_my_settings()
  AlterCommand <buffer> q :Scratch<CR>
endfunction
