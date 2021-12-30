
if !has_key(g:plugs, 'asyncomplete.vim')
  finish
end

inoremap <expr> <cr> pumvisible() ? <SID>decide() : "\<cr>"

let s:default_min_chars   = 0
let s:default_popup_delay = 100
let s:default_matcher     = 'start_with'
let s:settings = {
      \ 'go'   : {'min_chars': 0, 'popup_delay': 100 },
      \ 'html' : {'min_chars': 0, 'popup_delay': 50, 'matcher': 'fuzzy'},
      \}

augroup MyAllAsyncompleteStting
  autocmd!
  autocmd BufEnter *  call s:all_settings()
augroup END

function! s:decide()
  if asyncomplete#menu_selected()
    return "\<C-y>"
  endif
  return "\<C-n>\<C-c>a"
endfunction

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

let s:before_comp = ''
function! s:my_asyncomplete_preprocessor(options, matches) abort
  let visited = {}
  let targets = []
  let max_len = 5

  for key in s:toKeys(a:matches)
    if len(targets) >= max_len
      break
    endif

    let matches = a:matches[key.source_name]
    let base    = a:options.base

    let matcher = s:get_matcher()
    if base != "" && (key.source_name == 'file' || matcher == 'fuzzy')
      let res = s:complete_fuzzy(matches, base, targets, visited, max_len)
    else 
      let res = s:complete_start_with(matches, base, targets, visited, max_len)
    endif

    let targets = res.targets
    let visited = res.visited
  endfor

  let comp = s:toCompKey(targets)
  if s:before_comp != comp
    call s:invoke_complete(a:options, targets)
  endif

  let s:before_comp = comp
endfunction

function! s:complete_fuzzy(matches, base, targets, visited, max_len) abort
  if a:base == ""
    return s:merge(a:targets, [])
  endif

  let appendix = []
  let visited = a:visited
  let items = matchfuzzypos(a:matches['items'], a:base, {'key':'word'})[0]
  for item in items
    if has_key(visited, item.word)
      continue
    end
    call add(appendix, s:strip_pair_characters(a:base, item))
    let visited[item.word] = 1
    if len(a:targets) + len(appendix) >= a:max_len
      break
    endif
  endfor

  return s:merge(a:targets, appendix, visited)
endfunction

function! s:complete_start_with(matches, base, targets, visited, max_len)
  let appendix = []
  let visited = a:visited
  for item in a:matches['items']
    if has_key(visited, item.word)
      continue
    end
    let reg = "^" . a:base
    if item.word =~? reg
      call add(appendix, s:strip_pair_characters(a:base, item))
      let visited[item.word] = 1
      if len(a:targets) + len(appendix) >= a:max_len
        break
      endif
    endif
  endfor

  return s:merge(a:targets, appendix, visited)
endfunction

function! s:merge(targets, appendix, visited)
  let targets = a:targets
  let appendix = a:appendix
  call sort(appendix, {a,b -> len(a.word) > len(b.word)})
  let targets = a:targets + appendix

  return { 'targets': targets, 'visited': a:visited }
endfunction

function! s:invoke_complete(options, targets)
  call asyncomplete#preprocess_complete(a:options, a:targets)
  echo ""
endfunction

function! s:toCompKey(targets)
  let s = ''
  for v in a:targets
    let s .= v.word . '|'
  endfor
  return s
endfunction


function! s:toKeys(matches)
  let keys = []
  for key in keys(a:matches)
     let source = asyncomplete#get_source_info(key)
     let priority = 0
     if has_key(source, 'priority')
       let priority = source.priority
     endif
     call add(keys, {'source_name': key, 'priority': priority})
  endfor
  let keys = sort(keys, {a, b -> a.priority - b.priority})
  return keys
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
      \ 'allowlist': ['html'],
      \ 'blocklist': [],
      \ 'priority': 300,
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ 'config': {
        \    'max_buffer_size': 5000000,
        \  },
        \ }))

call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'allowlist': ['*'],
      \ 'priority': 300,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))

call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
      \ 'name': 'neosnippet',
      \ 'allowlist': ['*'],
      \ 'blocklist': [],
      \ 'priority': 100,
      \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
      \ }))


function! s:log(msg)
  " call webapi#http#post("localhost:5678", {"log": a:msg})
endfunction
