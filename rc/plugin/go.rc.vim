

let g:go_fmt_autosave = 0

command! GoFmt execute ':VimProcBang goimports -w %' | execute ':edit! %'
nnoremap gi :GoImports<CR>
