""""""""""""""""""""""""""""""
"          tweetvim          "
""""""""""""""""""""""""""""""

" tweetvim
nnoremap <silent> s           :exe ":silent TweetVimSay"<CR>
nnoremap <silent> <Space>re   :<C-u>TweetVimMentions<CR>
nnoremap <silent> <Space>a    :TweetVimListStatuses all<CR>
nnoremap <silent> t  :Unite -buffer-name=tweetvim tweetvim<CR>
nnoremap <silent> ta :TweetVimHomeTimeline<CR>
nnoremap <silent> th :TweetVimHomeTimeline<CR>
nnoremap <silent> tm :TweetVimMentions<CR>

command! Mentions     :call tweetvim#timeline('mentions')
command! -nargs=1 -complete=custom,tweetvim#complete#screen_name UserTimeline :call tweetvim#timeline('user_timeline', <f-args>)
command! -nargs=1 -complete=custom,tweetvim#complete#search SearchTweets :call tweetvim#timeline('search', <f-args>)

"let g:tweetvim_default_account = 'tottoruby'
let g:tweetvim_async_post = 1
let g:twibill_use_job = 1
let g:tweetvim_display_source = 1
let g:tweetvim_original_hi = 0
let g:tweetvim_filters = ['advanced']
let g:tweetvim_open_say_cmd = 'below split'
let g:tweetvim_display_icon = 1


if !has('gui_running')
  let g:tweetvim_display_source  = 0
  let g:tweetvim_empty_separator = 1
endif

augroup mygroup-tweetvim
  autocmd!
  autocmd FileType tweetvim_say call s:tweetvim_say_my_settings()
  autocmd FileType tweetvim setlocal nonu
augroup END

function! s:tweetvim_settings()
  nnoremap  <buffer><silent> O :call <SID>open_up_tweet()<cr>
endfunction

" for tweetvim say
function! s:tweetvim_say_my_settings()
  setlocal nocursorline
  AlterCommand <buffer> q bd!<CR>
  nnoremap <buffer> <silent> <C-j> :bd!<CR>
  if !has('gui_running')
    nnoremap <buffer> <silent> <esc> :bd!<CR>
  endif
"  inoremap <buffer> <C-x><C-d> <ESC>:TweetVimBitly<CR>
endfunction

