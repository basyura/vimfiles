
if !has_key(g:plugs, 'asyncomplete.vim')
  finish
end

inoremap <expr> <cr> pumvisible() ? <SID>decide() : "\<cr>"

let s:min_chars = 2
let s:popup_delay = 200
let s:settings = {
      \ 'go'   : {'min_chars': 0, 'popup_delay': 50},
      \ 'html' : {'min_chars': 2, 'popup_delay': 50},
      \}


function! s:decide()
  return "\<C-n>\<C-c>a"
endfunction

augroup MyAllAsyncompleteStting
  autocmd!
  autocmd BufEnter *  call s:all_settings()
augroup END

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

let s:before = {'len': 0, 'word': ''}
function! s:my_asyncomplete_preprocessor(options, matches) abort
  let l:visited = {}
  let l:items = []

  for [l:source_name, l:matches] in items(a:matches)
    let l:startcol = l:matches['startcol']
    let l:base = a:options['typed'][l:startcol - 1:]
    if l:base == ""
      continue
    endif
    for l:item in matchfuzzypos(l:matches['items'], l:base, {'key':'word'})[0]
      if has_key(l:visited, l:item.word)
        continue
      end
      call add(l:items, s:strip_pair_characters(l:base, l:item))
      let l:visited[l:item.word] = 1
    endfor
  endfor

  if len(l:items) == 0
    call asyncomplete#preprocess_complete(a:options, l:items)
    let s:before = {'len': 0, 'word': ''}
    return
  end

  if s:before.len != len(l:items) && s:before.word != l:items[0].word
    call asyncomplete#preprocess_complete(a:options, l:items)
  endif

  let s:before = {'len': len(l:items), "word": l:items[0].word}
endfunction

let s:pair = {
\  '"':  '"',
\  '''':  '''',
\}
function! s:strip_pair_characters(base, item) abort
  " Strip pair characters. If pre-typed text is '"', candidates
  " should have '"' suffix.
  let l:item = a:item
  if has_key(s:pair, a:base[0])
    let [l:lhs, l:rhs, l:str] = [a:base[0], s:pair[a:base[0]], l:item['word']]
    if len(l:str) > 1 && l:str[0] ==# l:lhs && l:str[-1:] ==# l:rhs
      let l:item = extend({}, l:item)
      let l:item['word'] = l:str[:-2]
    endif
  endif
  return l:item
endfunction

let g:asyncomplete_preprocessor = [function('s:my_asyncomplete_preprocessor')]



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


