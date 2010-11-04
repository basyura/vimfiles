
syn region  howmComment   start="/\*" end="\*/"
"syn region  howmImportant start=">|"  end="|<"
syn match  howmImportant "\s!\s.*"

syn match   howmTitle1  "^\* .*"
syn match   howmTitle2  "\s\*\* .*"
syn match   howmProblem ">>.*"



hi howmComment   guifg=DarkGrey
hi howmImportant guifg=orange
" underline がでない
hi howmTitle1  guifg=orange  gui=underline
hi howmTitle2  guifg=orange
hi howmProblem guifg=#FF80FF
hi howmTitle   guifg=#FF80FF gui=bold,underline
