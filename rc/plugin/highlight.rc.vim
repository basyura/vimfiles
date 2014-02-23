""""""""""""""""""""""""""""""""""
"            colors              "
""""""""""""""""""""""""""""""""""
hi Cursor  guifg=bg guibg=orange

hi tweetvim_reply ctermbg=5
hi tweetvim_appendix ctermfg=darkgray
hi PmenuSel ctermbg=darkblue ctermfg=white

hi J6uil_quotation ctermfg=gray

hi Error ctermbg=0 ctermfg=red

let java_ignore_javadoc = 1


"■ color for cygwin
if has('win32unix')
  hi Pmenu     ctermfg=LightYellow  ctermbg=black cterm=none
  hi PmenuSel  ctermfg=232          ctermbg=magenta
  hi Special   ctermfg=green        cterm=none
  hi PreProc   ctermfg=green        cterm=none
endif
