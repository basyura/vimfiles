""""""""""""""""""""""""""""""""""
"             unite              "
""""""""""""""""""""""""""""""""""

augroup MyGroup-unite
  autocmd!
  autocmd FileType unite  call s:unite_my_settings()
augroup END

nnoremap <silent> <C-r>      :<C-u>Unite -buffer-name=file_mru file_mru -start-insert -hide-source-names<CR>
if g:tab_mode
  nnoremap <silent> <C-n>      :<C-u>Unite -buffer-name=buffer -hide-source-names tab:no-current<CR>
else
  nnoremap <silent> <C-n>      :<C-u>Unite -buffer-name=buffer -hide-source-names buffer_tab<CR>
endif
nnoremap <silent> <Leader>d  :<C-u>Unite -buffer-name=files -hide-source-names file file/new<CR>
nnoremap <silent> <Leader>b  :<C-u>Unite -buffer-name=bookmark -no-start-insert bookmark<CR>
nnoremap <silent> <C-t>      :<C-u>Unite -buffer-name=tags tags -start-insert -hide-source-names<CR>
nnoremap <Leader>f  :<C-u>Unite file_rec -input=

let g:yankround_use_region_hl = 1
"nmap <C-s> <Plug>(yankround-next)
vmap <C-s> <Plug>(yankround-p)
"vmap <C-s> :<C-u>exe yankround#init('p')<Bar>call yankround#activate()<CR>
nmap <expr><C-s> yankround#is_active() ? "\<Plug>(yankround-prev)" : "<SID>(my_yankround)"
nnoremap <silent> <SID>(my_yankround) :Unite -buffer-name=history_yank yankround<CR>
"nmap <C-S> <Plug>(yankround-next)
inoremap <silent> <C-s> <Esc>:Unite -buffer-name=history_yank yankround<CR>
nnoremap <C-l> :call <SID>outline_or_snippet_jump()<CR>

function! s:outline_or_snippet_jump()
  if neosnippet#jumpable()
    "normal! 0
    "startinsert
    let cmd = neosnippet#mappings#jump_or_expand_impl()
    let cmd = substitute(cmd, "\<Esc>", '', 'g')
    let cmd = substitute(cmd, "\<CR>",  '', 'g')
    execute cmd
    return
  endif
  :Unite outline  -winwidth=40 -buffer-name=outline -hide-source-names
endfunction


nnoremap <Leader><Leader> :Unite 
"nnoremap <silent> <Leader>g :call <SID>grep()<CR>
nnoremap <silent> <Leader>g :Unite grep:.:: -no-quit -no-start-insert -direction=botright -buffer-name=grep -hide-source-names -keep-focus<CR>

function! s:grep()
  let word = input(' word : ')
  if word == ''
    redraw!
    return
  endif
  execute ':Unite grep:.::' . word . ' -no-quit -no-start-insert -direction=botright -buffer-name=grep -hide-source-names -keep-focus'
  let @/ = word
  set hlsearch
  :0
endfunction

if has('mac')
  nnoremap <silent> <Leader>e :Unite mdfind -buffer-name=mdfind<CR>
else
  nnoremap <silent> <Leader>e :Unite everything/async<CR>
endif

nnoremap <silent> <C-l><C-l> :Unite outline:!  -winheight=30 -buffer-name=outline<CR>
nnoremap <silent> <Space>r  :UniteResume<CR>
nnoremap man :Unite help<CR>
nnoremap <silent>co :Unite -no-quit -buffer-name=qflist qflist<CR>
nnoremap <silent><Leader>l  :<C-u>Unite -buffer-name=note -hide-source-names note<CR>
nnoremap <C-p> :Unite 
nnoremap <silent><C-h> :Unite -hide-source-names history/command<CR>
inoremap <C-x><C-x> <Esc>:Unite sudden-death -winheight=4 -hide-source-names<CR>

"let g:unite_source_history_yank_enable = 1
let g:unite_enable_start_insert = 1
" mru
let g:unite_source_file_mru_time_format    = ''
let g:unite_source_file_mru_ignore_pattern = '.*Application\ Data.*\|.*デスクトップ.*\|.*Local/Temp/.*\|\[quickrun output\]\|.*Local Settings/Temp/.*\|fugitive://\|\.git\|/private/var'
" unite ウインドウの高さ
let g:unite_winheight  = 10
let g:unite_split_rule = 'aboveleft'

let g:unite_source_everything_ignore_pattern = '\%(^\|/\)\.\.\?$\|\~$\|\.\%(git\|hg\|svn\)\|\.\%(o\|exe\|dll\|bak\|DS_Store\|pyc\|zwc\|sw[po]\)$\|\.xls$\|\.xlsx$\|\.zip$\|\.bmp$'

call unite#custom#source('file_rec/async', 'ignore_pattern', '\.dll$\|\.pdb$\|\.suo$\|\.png$\|\/Debug\/\|\/obj\/\|\/bin\/')


"call s:unite_substitute('', '[[:alnum:]]', '*\0', 100)
call Unite_substitute('file', '^\~', substitute(substitute($HOME, '\\', '/', 'g'), ' ', '\\\\ ', 'g'), -200)
if has('win32')
  call Unite_substitute('file', '[^~.]\zs/', '*/*', 20)
  call Unite_substitute('file', '/\ze[^*]', '/*'  , 10)
else
  call Unite_substitute('file', '[[:alnum:]]', '*\0', -150)
endif

call Unite_substitute('file_mru', '[[:alnum:]]', '*\0', 100)
call Unite_substitute('file_mru', '[^~.]\zs/', '*/*'  , 20)
call Unite_substitute('file_mru', '/\ze[^*]', '/*'    , 10)

call unite#custom_filters('buffer,buffer_tab,tab',
      \ ['matcher_file_name', 'sorter_default', 'converter_file_directory_tab'])

call unite#custom#source('file', 'matchers', 'matcher_fussy')

call unite#custom_filters('file_mru',
      \ ['matcher_file_name', 'sorter_default', 'converter_file_directory'])

call unite#custom_filters('uiki',
      \ ['matcher_fussy', 'sorter_default', 'converter_default'])

call unite#custom_filters('everything,everything/async,file_rec/async,mdfind',
      \ ['matcher_file_name', 'sorter_default', 'converter_file_directory_tab'])

call unite#custom_filters('history/command,outline',
      \ ['matcher_fussy', 'sorter_default', 'converter_default'])

call unite#custom_filters('hateblo-list',
      \ ['matcher_fussy', 'sorter_default', 'converter_hateblo'])

let g:unite_source_outline_cache_dir = ''
let g:unite_source_everything_limit = 300
let g:unite_source_everything_async_minimum_length = 3

call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')

if g:tab_mode
  call unite#custom_default_action('file'    , 'tabdrop')
  call unite#custom_default_action('file_rec', 'tabdrop')
endif

call unite#set_profile('buffer_tab,file,file_mru,everything', 'ignorecase', 1)
call unite#custom#profile('mdfind', 'required_pattern_length', 8)
call unite#custom#profile('default', 'context', {
\   'prompt_direction': 'top',
\   'prompt-visible'  : 1,
\   'start_insert'    : 1,
\ })

let my_absolute_path = {
\ 'is_selectable' : 1,
\ 'is_quit' : 0,
\ }
function! my_absolute_path.func(candidates)
  let candidate = a:candidates[0]
  let path      = candidate.action__directory
  if candidate.kind == 'directory'
    let path = fnamemodify(path . '/../', ':p')
  else
    let path = fnamemodify(path, ':p:h') . '/'
  end
  call unite#start([['file'], ['file/new']],unite#get_context())
  call unite#mappings#narrowing(path)
endfunction
call unite#custom_action('file', 'absolute_path', my_absolute_path)
unlet my_absolute_path

function! s:unite_my_settings()

  imap <buffer> jj <Plug>(unite_insert_leave)
  imap <buffer> <C-j> <Esc>c<Plug>(unite_all_exit)
  imap <buffer> <ESC> <Esc><Plug>(unite_all_exit)
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  inoremap <buffer><expr> <C-g> unite#do_action('grep_directory')
  inoremap <buffer><expr> <C-@> unite#do_action('absolute_path')
  inoremap <buffer><expr> <C-x><C-i> unite#do_action('insert')
  inoremap <buffer><expr> <C-y> unite#do_action('yank')
  inoremap <silent><buffer> <C-a> <Esc>:call <SID>move_head()<CR>
	noremap <silent><buffer><expr> <C-x><C-i> unite#do_action('insert')
  imap <buffer> <C-e> <Enter>
  nmap <buffer> <C-n> <Plug>(unite_loop_cursor_down)
  nmap <buffer> <C-p> <Plug>(unite_loop_cursor_up)
  nmap <buffer> <C-j> <Plug>(unite_exit)
  imap <buffer> <C-r> <Plug>(unite_redraw)

  inoremap <buffer> <C-v> <C-r>0
  inoremap <buffer> <C-f> <Right>
  inoremap <buffer> <C-b> <Left>
  inoremap <silent><buffer><expr> <C-d> unite#do_action('delete')
  if has('mac')
    inoremap <silent><buffer><expr> <C-s> unite#do_action('mdfind')
  else
    inoremap <silent><buffer><expr> <C-s> unite#do_action('rec_parent/async')
  endif

  map <silent><buffer> a <Plug>(unite_insert_enter)

  "startinsert
endfunction

function! s:move_head()
  set modifiable
  if line(".") == 1
    if getline(1) != '> '
      normal! 0ll
      startinsert
    else
      startinsert!
    end
  else
    :0
    startinsert!
  end
endfunction

let g:unite_source_alias_aliases = {
\   "gvalue" : {
\       "source" : "output",
\       "args" : 'echo join(map(keys(g:),"''g:''.v:val"),"\n")'
\   }
\}

