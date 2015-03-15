""""""""""""""""""""""""""""""""""
"            vimfiler            "
""""""""""""""""""""""""""""""""""

let g:vimfiler_as_default_explorer = 1
let g:vimfiler_no_default_key_mappings = 1

augroup MyVimFiler
  autocmd!
  autocmd FileType vimfiler call s:vimfiler_setting()
augroup END

function! s:vimfiler_setting()
  nmap <buffer> l <Plug>(vimfiler_smart_l):CD<CR>
  nmap <buffer> h <Plug>(vimfiler_smart_h):CD<CR>
  nmap <buffer>	e <Plug>(vimfiler_edit_file)
endfunction
