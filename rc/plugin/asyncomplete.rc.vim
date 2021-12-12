
inoremap <expr> <cr>    pumvisible() ? <SID>decide() : "\<cr>"

function! s:decide()
  return "\<C-n>\<C-c>a"
endfunction

let g:asyncomplete_popup_delay = 150
let g:asyncomplete_min_chars = 0

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
     \ 'name': 'buffer',
     \ 'allowlist': ['ruby'],
     \ 'blocklist': [],
     \ 'completor': function('asyncomplete#sources#buffer#completor'),
     \ 'config': {
     \    'max_buffer_size': 5000000,
     \  },
     \ }))


au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'allowlist': ['*'],
      \ 'priority': 10,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))
