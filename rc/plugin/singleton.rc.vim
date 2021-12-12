
" singleton.vim
if has('clientserver') && !has('mac')
  call singleton#enable()
  let g:singleton#opener = "drop"
endif

