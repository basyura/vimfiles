" wombat 用 highlight

hi Cursor   guifg=bg    guibg=orange
hi Visual   guifg=black guibg=#bde682
hi VimShellUserPrompt guifg=#95e454
hi VimShellPrompt guifg=#8ac6f2 gui=NONE
hi VimShellError  guifg=#e5786d
hi Comment             gui=none
hi String              gui=none
hi StatusLine  gui=none
hi IncSearch guifg=red guibg=white
hi Search term=reverse ctermfg=0 ctermbg=14 guifg=Black guibg=#EAE49D

hi txtHeader  guifg=#cae682 gui=bold
hi txtHeader2 guifg=orange gui=underline
hi txtBold    guifg=#cae682 gui=bold

" unite
hi Unite_Cursor_Line guibg=#00008b
hi uniteSource__FileMru_Time guifg=darkgray

hi clear Conceal
hi Conceal  ctermfg=7 ctermbg=8 guifg=orange

hi Title gui=none guifg=orange
" tweetvim
hi tweetvim_separator_title guifg=#5f5f5f
hi tweetvim_separator       guifg=#414141

"note
hi noteH1               guifg=orange
hi noteH2               guifg=orange
hi noteH3               guifg=orange
hi noteHeadingRule      guifg=orange
hi noteHeadingDelimiter guifg=orange
hi note_strong          guifg=magenta
hi noteCodeBlock        guifg=#cae682
hi noteCode             guifg=#cae682

if has('win32')
  hi Normal guifg=#ffffff
endif
