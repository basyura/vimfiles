
syn region markdownCode matchgroup=markdownCodeDelimiter start="`" end="`" contains=markdownLineStart

"hi Cursor		guibg=orange guifg=black
hi Comment 		gui=none
hi String 		gui=none
hi StatusLine 	gui=none
"hi PreProc      guifg=#ffffff
"hi Folded       guifg=white
"hi Visual       guifg=black guibg=#CAE682
hi CursorLine   guibg=blue

hi markdownH1   guifg=orange
hi markdownH2   guifg=orange
"markdownH3     xxx links to htmlH3
"markdownH4     xxx links to htmlH4
"markdownH5     xxx links to htmlH5
"markdownH6     xxx links to htmlH6
hi markdownBlockquote guifg=#80a0ff
"markdownListMarker xxx links to htmlTagName
"markdownOrderedListMarker xxx links to markdownListMarker
hi markdownCodeBlock guifg=#cae682
"markdownRule   xxx links to PreProc
"markdownLineBreak xxx cleared
"markdownLinkText xxx links to htmlLink
hi markdownItalic guifg=#bee8ff gui=italic
hi markdownBold   guifg=#ff9be8
hi markdownCode   guifg=#cae682
"markdownEscape xxx links to Special
"markdownHeadingRule xxx links to markdownRule
hi markdownHeadingDelimiter guifg=orange
"markdownLinkDelimiter xxx cleared
"markdownUrl    xxx links to Float
"markdownIdDeclaration xxx links to Typedef
"markdownUrlTitle xxx links to String
"markdownUrlDelimiter xxx links to htmlTag
"markdownUrlTitleDelimiter xxx links to Delimiter
"markdownLinkTextDelimiter xxx cleared
"markdownLink   xxx cleared
"markdownId     xxx links to Type
"markdownIdDelimiter xxx links to markdownLinkDelimiter
"markdownAutomaticLink xxx links to markdownUrl
"markdownBoldItalic xxx links to htmlBoldItalic
"markdownCodeDelimiter xxx links to Delimiter

