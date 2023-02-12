if !has_key(g:plugs, 'asyncomplete.vim')
  finish
end

function! s:alias(base, types)
  for typ in a:types
    let s:settings[typ] = s:settings[a:base]
  endfor
endfunction


let s:use_my_processor = 1

inoremap <expr> <cr> pumvisible() ? <SID>decide() : "\<cr>"

let s:default_min_chars   = 1
let s:default_popup_delay = 100
let s:default_matcher     = 'starts_with'

let s:settings = {
      \ 'go'   : {'min_chars': 1, 'popup_delay': 100 },
      \ 'js'   : {'min_chars': 2, 'popup_delay': 100 },
      \ 'html' : {'min_chars': 0, 'popup_delay': 50, 'matcher': 'fuzzy'},
      \ 'markdown' : {'ignoreCase': 0},
      \}

call s:alias('js', ['typescriptreact', 'javascript.jsx'])

let g:async_comp_settings = s:settings

augroup MyAllAsyncompleteStting
  autocmd!
  autocmd BufEnter *  call s:all_settings()
augroup END

function! s:decide()
  " Already item is selected.
  if asyncomplete#menu_selected()
    if s:is_method(v:completed_item)
      return "\<C-y>()\<Left>"
    endif
    return "\<C-y>"
  endif

  " Select first item.
  " Complete '(' if item's kind id function.
  if s:is_method(complete_info().items[0])
    return "\<C-n>\<C-c>a()\<Left>"
  endif
  return "\<C-n>\<C-c>a"
endfunction

function! s:is_method(item)
  let kind = get(a:item, 'kind', '')
  if kind == 'function' || kind == 'method'
    return 1
  endif
  return 0
endfunction

function! s:all_settings()
  let pair = s:to_pair()
  let g:asyncomplete_min_chars = pair['min_chars']
  let g:asyncomplete_popup_delay = pair['popup_delay']
endfunction

function! s:to_pair()
  let param = {'min_chars': s:default_min_chars, 'popup_delay': s:default_popup_delay}
  if has_key(s:settings, &filetype)
    let param = extend(param, s:settings[&filetype])
  end
  return param
endfunction

let b:before_comp = ''
function! s:my_asyncomplete_preprocessor(options, matches) abort

  let state = {
        \ "max_len": 5,
        \ "items": [],
        \ "visited": {},
        \}

  " key : priority, source_name
  for key in s:toKeys(a:matches)
    if len(state.items) >= state.max_len
      break
    endif

    let setting = get(s:settings, &filetype, {})
    let matcher = get(setting, 'matcher', s:default_matcher)

    if matcher == 'fuzzy'
      let items = s:gather_fuzzy(state, key.source_name, a:options, a:matches[key.source_name], setting)
    else 
      let items = s:gather_starts_with(state, key.source_name, a:options, a:matches[key.source_name], setting)
    endif
    let state.items += items
  endfor

  let comp = ""
  for item in state.items
    let comp .= item.word . "_"
  endfor
  if get(b:, "before_comp", "") != comp
    call s:invoke_complete(a:options, state.items)
  end
  let b:before_comp = comp
endfunction

function! s:gather_fuzzy(state, source_name, options, match, setting) abort
  if a:options.base == ""
    return []
  endif

  let appendix = []
  let items = matchfuzzypos(a:match['items'], a:options.base, {'key':'word'})[0]
  for item in items
    if has_key(a:state.visited, item.word)
      continue
    end

    call add(appendix, s:strip_pair_characters(a:options.base, item))
    let a:state.visited[item.word] = 1
    if len(a:state.items) + len(appendix) >= a:state.max_len
      break
    endif
  endfor

  return s:sort(appendix)
endfunction

function! s:gather_starts_with(state, source_name, options, match, setting)
  let isDebug = 0 "{{{
   " if a:source_name == "asyncomplete_lsp_gopls"
   " if a:source_name == "asyncomplete_lsp_typescript-language-server"
   " if a:source_name == "file"
   " if a:source_name == "asyncomplete_lsp_vim-language-server"
   "  let isDebug = 1
  " endif
  "}}}

  " a:options.base を見て補完候補を見れば良かったのだけど、
  " file が動くとそうでもなくなる考慮を追加
  " file は補完対象が無い場合に asyncomplete#complete を呼ばないようにして回避
  let appendix = []
  let comp_prefix = a:options.typed[a:options.startcol-1:a:match.startcol-2]
  let comp_word = a:options.typed[a:match.startcol-1:a:options.col]
  let reg = "^" . escape(comp_word, '~')

  if isDebug "{{{
    call s:log("\n## " . a:source_name . " : ---------------------")
    call s:log("┌─ options")
    call s:log("typed    : [" . a:options.typed  . "]")
    call s:log("col      : [" . a:options.col . "] → [" . a:options.typed[a:options.col:])
    call s:log("startcol : [" . a:options.startcol . "] → [" . a:options.typed[a:options.startcol:])
    call s:log("base     : [" . a:options.base . "]")
    call s:log("prefix   : [" . comp_prefix . "]")
    call s:log("word     : [" . comp_word . "]")
    call s:log("reg      : [" . reg . "]")
    call s:log("┌─ match")
    call s:log("ctx.typed : " . a:match.ctx.typed)
    call s:log("ctx.col   : " . a:match.ctx.col . " → [" . a:options.typed[a:match.ctx.col:])
    call s:log("startcol  : " . a:match.startcol. " → [" . a:options.typed[a:match.startcol:])
  end "}}}

  if comp_word == ""
    return []
  end

  for item in a:match['items']
    let word = item.word
    if has_key(a:state.visited, word)
      continue
    end

    if a:source_name != "file" && stridx(word, ".") >= 0
      continue
    end

    let isIgnoreCase = get(a:setting, "ignoreCase", 1)
    if (isIgnoreCase && word =~? reg) || (!isIgnoreCase && word =~# reg)
      " neosnippet の word が重複していくのでコピーするようにしたが file を見直したら発生しなくなった
      " おかしな場所で補完されるようになったので comp_prefix をつけたが file を略
      if a:options.typed != a:options.base
        " let item = json_decode(json_encode(item))
        let item.word = comp_prefix . item.word
      end

      if isDebug "{{{
        if  a:options.typed != a:options.base
          call s:log("→ " . word . " → " . item.word . " <copied>")
          call s:log("→ " . json_encode(item))
        else
          call s:log("→ " . word . " → " . item.word)
        end
      end "}}}

      call add(appendix, item)
      let a:state.visited[item.word] = 1
      if len(a:state.items) + len(appendix) >= a:state.max_len
        break
      endif
    endif
  endfor

  return s:sort(appendix)
endfunction

function! s:sort(appendix)
  return sort(a:appendix, {a,b -> len(a.word) - len(b.word)})
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

if s:use_my_processor
  let g:asyncomplete_preprocessor = [function('s:my_asyncomplete_preprocessor')]
endif

command! OnProcessor call s:change_processor(1)
command! OffProcessor call s:change_processor(0)
function! s:change_processor(flg)
  if a:flg
    let g:asyncomplete_preprocessor = [function('s:my_asyncomplete_preprocessor')]
  else
    let g:asyncomplete_preprocessor = []
  end
endfunction



call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'buffer',
      \ 'allowlist': ['html','zsh','less','css', 'markdown', 'md'],
      \ 'blocklist': ['unite'],
      \ 'priority': 200,
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ 'config': {
        \    'max_buffer_size': 5000000,
        \  },
        \ }))


call asyncomplete#register_source(asyncomplete#sources#neosnippet#get_source_options({
      \ 'name': 'neosnippet',
      \ 'allowlist': ['*'],
      \ 'blocklist': ['unite'],
      \ 'priority': 100,
      \ 'completor': function('asyncomplete#sources#neosnippet#completor'),
      \ }))

call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'file',
      \ 'allowlist': ['*'],
      \ 'blocklist': ['unite'],
      \ 'priority': 0,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))


function! s:log(msg)
  " call webapi#http#post("localhost:5678", {"log": a:msg})
  let outputfile = "$HOME/Desktop/asyncomplete.log"
  execute ":redir! >> " . outputfile
    silent! echon a:msg . "\n"
  redir END
endfunction

" vim: foldmethod=marker
