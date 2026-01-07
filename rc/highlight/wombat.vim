" wombat 用 highlight

hi Cursor   guifg=bg    guibg=orange
hi Visual   guifg=black guibg=#bde682
hi VimShellUserPrompt guifg=#95e454
hi VimShellPrompt guifg=#8ac6f2 gui=NONE
hi VimShellError  guifg=#e5786d
hi Comment             gui=none
hi String              gui=none
hi StatusLine    ctermfg=Gray  gui=none
hi StatusLineNC  ctermfg=Gray  gui=none
hi IncSearch guifg=red guibg=white
hi Search term=reverse ctermfg=0 ctermbg=14 guifg=Black guibg=#EAE49D
hi ModeMsg gui=none guifg=gray

hi txtHeader  guifg=#cae682 gui=bold
hi txtHeader2 guifg=orange gui=underline
hi txtBold    guifg=#cae682 gui=bold

hi SignColumn guibg=NONE ctermbg=NONE
hi CursorLineSign guibg=NONE ctermbg=NONE
hi LineNr guibg=bg

" unite
hi Unite_Cursor_Line guibg=#00008b
hi uniteSource__FileMru_Time guifg=darkgray

hi clear Conceal
hi Conceal  ctermfg=7 ctermbg=8 guifg=orange

hi Title gui=none guifg=orange

if has('win32')
  hi Normal guifg=#ffffff
endif
