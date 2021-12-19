
if !has_key(g:plugs, 'asyncomplete.vim')
  finish
end

inoremap <expr> <cr> pumvisible() ? <SID>decide() : "\<cr>"

let s:default_min_chars   = 0
let s:default_popup_delay = 200
let s:default_matcher     = 'start_with'
let s:settings = {
      \ 'go'   : {'min_chars': 0, 'popup_delay': 100 },
      \ 'html' : {'min_chars': 2, 'popup_delay': 50, 'matcher': 'fuzzy'},
      \}

function! s:decide()
  if asyncomplete#menu_selected()
    return "\<C-y>"
  endif
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

  return {'min_chars': s:default_min_chars, 'popup_delay': s:default_popup_delay}
endfunction

function! s:get_matcher()
  let setting = get(s:settings, &filetype, {})
  return get(setting, 'matcher', s:default_matcher)
endfunction

let s:before = {'len': 0, 'word': ''}
function! s:my_asyncomplete_preprocessor(options, matches) abort
  let visited = {}
  let targets = []

  for [source_name, matches] in items(a:matches)
    let startcol = matches['startcol']
    let base = a:options['typed'][startcol - 1:]
    if base == ""
      continue
    endif

    let matcher = s:get_matcher()
    if source_name == 'file' || matcher == 'fuzzy'
      for item in matchfuzzypos(matches['items'], base, {'key':'word'})[0]
        if has_key(visited, item.word)
          continue
        end
        call add(targets, s:strip_pair_characters(base, item))
        let visited[item.word] = 1
      endfor
    else 
      " start with
      for item in matches['items']
        if has_key(visited, item.word)
          continue
        end
        let reg = "^" . base
        try
        if item.word =~? reg
          call add(targets, s:strip_pair_characters(base, item))
          let visited[item.word] = 1
        endif
      catch
        echom source_name
        echom item
        echom v:exception
      endtry
      endfor
    endif

  endfor

  if len(targets) == 0
    if s:before.len != 0
      call asyncomplete#preprocess_complete(a:options, targets)
    endif
    let s:before = {'len': 0, 'word': ''}
    return
  end

  if s:before.len != len(targets) && s:before.word != targets[0].word
    call asyncomplete#preprocess_complete(a:options, targets)
  endif

  let s:before = {'len': len(targets), "word": targets[0].word}
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
      \ 'allowlist': ['*'],
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
