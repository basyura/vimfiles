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



"let g:tweetvim_default_account = 'tottoruby'
let g:tweetvim_display_source = 1
let g:tweetvim_original_hi = 0
let g:tweetvim_filters = ['advanced']

let g:tweetvim_advanced_filter = {}
function! g:tweetvim_advanced_filter.executor(tweet)
  if !has_key(a:tweet, 'user')
    return 0
  endif
  
  if a:tweet.user.screen_name == 'rails_rt_ja'
    return 1
  endif

  if a:tweet.user.screen_name == 'takapon_jp' && has_key(a:tweet, 'retweeted_status')
    return 1
  endif

  if a:tweet.text =~ '^デイリー こで'
    return 1
  endif

  return 0
endfunction


if !has('gui_running')
  let g:tweetvim_display_source  = 0
  let g:tweetvim_empty_separator = 1
endif

augroup mygroup-tweetvim
  autocmd!
  autocmd FileType tweetvim_say call s:tweetvim_say_my_settings()
  autocmd FileType tweetvim setlocal nonu
  autocmd FileType tweetvim call s:tweetvim_settings()
augroup END

function! s:tweetvim_settings()
  nnoremap  <buffer><silent> O :call <SID>open_up_tweet()<cr>
endfunction

" for tweetvim say
function! s:tweetvim_say_my_settings()
  AlterCommand <buffer> q bd!<CR>
  nnoremap <buffer> <silent> <C-j> :bd!<CR>
  if !has('gui_running')
    nnoremap <buffer> <silent> <esc> :bd!<CR>
  endif
"  inoremap <buffer> <C-x><C-d> <ESC>:TweetVimBitly<CR>
endfunction

function! s:open_up_tweet()
 call tweetvim#action#cursor_up#execute({})
 let tweet = b:tweetvim_status_cache[line(".")]
 call tweetvim#action#open_links#execute(tweet)
 call tweetvim#action#cursor_down#execute({})
endfunction

