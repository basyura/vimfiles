""""""""""""""""""""""""""""""""""
"        open browser            "
""""""""""""""""""""""""""""""""""

"let g:openbrowser_format_message = "opening ... {done ? 'done! ({command})' : ''}"
let g:openbrowser_format_message = {
\   'msg': "opening ... {done ? 'done! ({command})' : ''}",
\   'truncate': 1,
\   'min_uri_len': 15,
\}
