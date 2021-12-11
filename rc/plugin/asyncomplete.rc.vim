
inoremap <expr> <cr>    pumvisible() ? <SID>decide() : "\<cr>"

function! s:decide()
  return "\<C-n>\<C-c>a"
endfunction

let g:asyncomplete_popup_delay = 200
let g:asyncomplete_min_chars = 0
