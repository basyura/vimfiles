" highlight for newspaper 

if has('mac')
  set transparency=0
endif
"hi Cursor  guifg=black    guibg=orange
"hi Cursor  guifg=bg   guibg=#557788
hi Cursor guibg=#Cd853f guifg=fg
"hi CursorLine guibg=#D2D2D2
hi CursorLine guibg=#cccfbf
hi CursorLineNr guifg=#666677 guibg=#cccfbf gui=none
hi Comment guifg=darkgray gui=none
hi helpExample guifg=darkblue
hi vimshellPrompt guifg=darkgreen
hi PmenuSel ctermfg=255 ctermbg=21 gui=none guifg=#ffffff guibg=#716d51 
hi Error   guifg=red gui=none
"hi StatusLine   guibg=#cccfbf guifg=#716d51 gui=none 
"hi StatusLineNC guibg=#cccfbd guifg=#716d51 gui=none term=reverse ctermfg=253 ctermbg=110 

hi tweetvim_reply            guifg=brown guibg=#d3d47a
hi tweetvim_screen_name      guifg=#2C773D
hi tweetvim_at_screen_name   guifg=#2C773D
hi tweetvim_rt_count         guifg=#FF0000
hi tweetvim_appendix         guifg=gray
hi tweetvim_star             guifg=orange
hi tweetvim_separator        guifg=gray
hi tweetvim_separator_title  guifg=gray
hi tweetvim_hash_tag         guifg=blue

hi ModeMsg   guifg=darkgray gui=none
hi Question  guifg=darkgray gui=none
hi Search    guifg=#ffffff guibg=#7B7939
hi IncSearch guifg=#000000 guibg=#adadad
hi VimError  guibg=#dcdda8
hi Pmenu     guifg=brown

hi noteH1 guifg=brown
hi noteHeadingRule guifg=brown
hi noteHeadingDelimiter guifg=brown
hi note_strong guifg=red

let g:vimshell_escape_colors = ['#6c6c6c', '#ff6666', '#0000ff', '#a22727', '#1e95fd', '#ff13ff', 'darkgreen', '#C0C0C0', '#383838', '#ff4444', '#44ff44', '#ffb30a', '#6699ff', '#f820ff', '#4ae2e2', '#ffffff']

hi J6uil_separator guifg=gray
hi J6uil_quotation guifg=#557788

hi uniteSource__FileMru_Time guifg=#9f9f9f
hi uniteSource__Buffer_Time  guifg=#9f9f9f
hi uniteSource__Buffer_Name  guifg=#000000

if has('win32')
  hi YankRoundRegion  guibg=#DCDDA8
else
  hi YankRoundRegion  guibg=#C7D358
endif
