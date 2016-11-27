
command! Lingr  :J6uil

augroup MyGroup-j6uil
  autocmd!
  autocmd FileType J6uil          call s:j6uil_settings()
  autocmd FileType J6uil_rooms    call s:j6uil_other_settings()
  autocmd FileType J6uil_members  call s:j6uil_other_settings()
  "colorscheme desert
augroup END

function! s:j6uil_settings()
  nnoremap <silent><buffer><C-n> :J6uilNextRoom<CR>
  nnoremap <silent><buffer><C-p> :J6uilPrevRoom<CR>
  set laststatus=0
  set nocursorline
endfunction

function! s:j6uil_other_settings()
  set nocursorline
endfunction
