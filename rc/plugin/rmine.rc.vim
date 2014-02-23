" rmine

augroup My-Rmine-Group
  autocmd!
  autocmd FileType rmine_issues setlocal cursorline
  autocmd FileType rmine_issues,rmine_issue call s:rmine_my_settings()
augroup END

function! s:rmine_my_settings()
  nnoremap <buffer> s :echo "can not tweet"<CR>
  hi rmine_pre guifg=darkgreen
  hi rmine_appendix guifg=darkgray
  hi rmine_issues_separator_title guifg=gray
  hi rmine_issues_separator guifg=gray
  hi rmine_issue_priority_6 guifg=red
  hi rmine_issue_status_3 guifg=white guibg=#675220
endfunction
