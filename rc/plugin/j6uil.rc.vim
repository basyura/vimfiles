
command! Lingr :J6uil

augroup MyGroup-j6uil
  autocmd!
  autocmd FileType J6uil  call s:j6uil_settings()
augroup END

function! s:j6uil_settings()
  nnoremap <silent><buffer><C-n> :J6uilNextRoom<CR>
  nnoremap <silent><buffer><C-p> :J6uilPrevRoom<CR>
endfunction
