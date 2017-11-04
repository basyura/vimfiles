
command! GoFmt execute ':VimProcBang goimports -w %' | execute ':edit! %'
nnoremap gi :GoImports<CR>
