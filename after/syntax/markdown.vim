
syn region markdownCode matchgroup=markdownCodeDelimiter start="`" end="`" contains=markdownLineStart


if g:colors_name == 'solarized'
  hi markdownH1 guifg=brown
  hi markdownH2 guifg=brown
  hi markdownH3 guifg=brown
  hi markdownHeadingDelimiter guifg=brown
  finish
endif


hi Comment 		gui=none
hi String 		gui=none
hi StatusLine 	gui=none

hi markdownH1   guifg=orange
hi markdownH2   guifg=orange
hi markdownH3   guifg=#8ac6f2
hi markdownBlockquote guifg=#80a0ff
hi markdownItalic gui=none
hi markdownBold   guifg=#ff9be8
hi markdownCode   guifg=#cae682
hi markdownHeadingDelimiter guifg=#8ac6f2
