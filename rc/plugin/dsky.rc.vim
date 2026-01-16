
nnoremap <silent> s :exe ":silent DSkySay"<CR>
nnoremap <silent> ta :DSkyTimeline<CR>
nnoremap <silent> tm :DSkyNotifications<CR>

command! -nargs=* -complete=customlist,dsky#handle#complete UserFeed
      \ execute 'DSkyAuthorFeed ' . <q-args>
