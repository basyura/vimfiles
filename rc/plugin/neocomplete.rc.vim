" necocomplete 
function! s:initialize_neocomplete()
  let g:neocomplete#enable_at_startup= 1
	if !exists('g:neocomplete#keyword_patterns')
	    let g:neocomplete#keyword_patterns = {}
	endif
	let g:neocomplete#keyword_patterns._ = '\h\w*'

	if !exists('g:neocomplete#sources#dictionary#dictionaries')
    let g:neocomplete#sources#dictionary#dictionaries = {}
  endif
  let dict = g:neocomplete#sources#dictionary#dictionaries
  let dict.ruby   = $HOME . '/.vim/dict/ruby.dict'
  let dict.cs     = $HOME . '/.vim/dict/cs.dict'
  let dict.elixir = $HOME . '/.vim/dict/elixir.dict'
  "let dict._ = $HOME . '/.vim/dict/default.dict'
  "let dict.tweetvim_say =  $HOME . '/.tweetvim/screen_name,' .
                         "\ $HOME . '/.tweetvim/hash_tag,'
  
  let g:neocomplete#sources#buffer#disabled_pattern = '\.log\|\.log\.\|\.jax\|Log.txt'
  let g:neocomplete#enable_ignore_case = 0
  "let g:neocomplete#enable_smart_case  = 1
  let g:neocomplete#enable_fuzzy_completion = 0

  call neocomplete#custom_source('_', 'sorters',  ['sorter_length'])
  call neocomplete#custom_source('_', 'matchers', ['matcher_head'])
  call neocomplete#custom_source('neosnippet', 'rank',  400)

  call neocomplete#custom_source('include', 'rank', 1)

  if has('patch22')
    let g:neocomplete#enable_auto_select = 1
    inoremap <expr><CR>   pumvisible() ? neocomplete#close_popup()  : "<CR>"
  else
    inoremap <expr><CR>   pumvisible() ? "\<C-n>" . neocomplete#close_popup()  : "<CR>"
  endif

  inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
  inoremap <expr><C-e>  pumvisible() ? neocomplete#close_popup() : "<End>"
  inoremap <expr><C-c>  neocomplete#cancel_popup()
  "inoremap <expr><C-u>  neocomplete#undo_completion()
  inoremap <expr><C-h>  neocomplete#smart_close_popup()."\<C-h>"
endfunction


if !has('win32unix')
  call s:initialize_neocomplete()
  call neocomplete#initialize()
endif

