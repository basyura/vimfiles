
inoremap <expr> <cr> pumvisible() ? <SID>decide() : "\<cr>"

function! s:decide()
  return "\<C-n>\<C-c>a"
endfunction

let s:min_chars = 2
let s:popup_delay = 200

augroup MyAllAsyncompleteStting
  autocmd!
  autocmd BufEnter *  call s:all_settings()
augroup END

let s:settings = {
      \ 'html' : {'min_chars': 2, 'popup_delay': 50},
      \}

function! s:all_settings()
  let pair = s:to_pair()
  let g:asyncomplete_min_chars = pair['min_chars']
  let g:asyncomplete_popup_delay = pair['popup_delay']
endfunction

function! s:to_pair()
  if has_key(s:settings, &filetype)
    return s:settings[&filetype]
  end

  return {'min_chars': s:min_chars, 'popup_delay': s:popup_delay}
endfunction


call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'allowlist': ['ruby', 'html'],
      \ 'blocklist': [],
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ 'config': {
        \    'max_buffer_size': 5000000,
        \  },
        \ }))

call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'allowlist': ['*'],
      \ 'priority': 10,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))

call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
      \ 'name': 'neosnippet',
      \ 'allowlist': ['*'],
      \ 'blocklist': [],
      \ 'priority': 100,
      \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
      \ }))


