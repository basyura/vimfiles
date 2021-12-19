
if !has_key(g:plugs, 'asyncomplete.vim')
  finish
end

inoremap <expr> <cr> pumvisible() ? <SID>decide() : "\<cr>"

let s:default_min_chars   = 2
let s:default_popup_delay = 100
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

let s:before_comp = ''
function! s:my_asyncomplete_preprocessor(options, matches) abort
  let visited = {}
  let targets = []
  let max_len = 5

  for key in s:toKeys(a:matches)
    let matches = a:matches[key.source_name]
    if len(targets) >= max_len
      break
    endif

    let startcol = matches['startcol']
    let base = a:options['typed'][startcol - 1:]
    if base == ""
      continue
    endif

    let matcher = s:get_matcher()
    if key.source_name == 'file' || matcher == 'fuzzy'
      for item in matchfuzzypos(matches['items'], base, {'key':'word'})[0]
        if has_key(visited, item.word)
          continue
        end
        call add(targets, s:strip_pair_characters(base, item))
        let visited[item.word] = 1
        if len(targets) >= max_len
          break
        endif
      endfor
    else 
      " start with
      for item in matches['items']
        if has_key(visited, item.word)
          continue
        end
        let reg = "^" . base
        if item.word =~? reg
          call add(targets, s:strip_pair_characters(base, item))
          let visited[item.word] = 1
          if len(targets) >= max_len
            break
          endif
        endif
      endfor
    endif
  endfor

  " let s = join(map(copy(targets), 'v:val.word'), '|')
  let comp = ''
  for v in targets
    let comp .= v.word . '|'
  endfor

  if len(targets) == 0
    if s:before_comp != ''
      call s:invoke_complete(a:options, targets)
    endif
  elseif s:before_comp != comp
      call s:invoke_complete(a:options, targets)
  endif

  let s:before_comp = comp
endfunction

function! s:invoke_complete(options, targets)
  call asyncomplete#preprocess_complete(a:options, a:targets)
  echo ""
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
      \ 'allowlist': ['*'],
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
      \ 'priority': 200,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))

call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
      \ 'name': 'neosnippet',
      \ 'allowlist': ['*'],
      \ 'blocklist': [],
      \ 'priority': 100,
      \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
      \ }))
