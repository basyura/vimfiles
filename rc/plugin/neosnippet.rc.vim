" ■ snippet 補完
let g:neosnippet#snippets_directory = '~/.vim/snippets'
let g:neosnippet#disable_runtime_snippets = { '_' : 1 }
imap <expr><C-l> pumvisible() ?
      \ "\<C-y><Plug>(neosnippet_expand_or_jump)"
      \ : "<Plug>(neosnippet_expand_or_jump)"
"imap <C-l> <Plug>(neosnippet_expand_or_jump)
smap <C-l> <Plug>(neosnippet_expand_or_jump)

command! -nargs=* Nes NeoSnippetEdit <args>
