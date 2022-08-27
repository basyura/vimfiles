
let g:lsp_log_file = ""
let g:lsp_preview_doubletap = 0
let g:lsp_preview_max_height = 2
"let g:lsp_diagnostics_enabled = 0
"
 let g:lsp_settings = {
 \  'typescript-language-server': {
 \    'allowlist': ['js', 'javascript','javascript.jsx', 'ts', 'typescript', 'typescriptreact'],
 \   },
 \ }

command! ResetLsp call s:reset_lsp()

" function! Apply_lsp_common_settings()
"   call s:on_lsp_buffer_enabled()
" endfunction

function! s:on_lsp_buffer_enabled()
  if get(b:, "my_lsp_buffer_enabled", 0)
    return 
  endif
  let b:my_lsp_buffer_enabled = 1

  setlocal omnifunc=lsp#complete

  nnoremap <buffer> gd :LspDefinition<CR>
  nnoremap <buffer> <C-k> :call <SID>lsp_definition()<CR>
  nnoremap <buffer> K :LspHover<CR>
  nnoremap <buffer> <Leader>r :LspRename<CR>
  nnoremap <buffer> <C-x><C-f> :LspDocumentFormat<CR>
  " nnoremap <buffer> <C-x><C-d> :LspDocumentDiagnostic<CR><C-w>p
  nnoremap <buffer> <C-x><C-d> :call lsp_popup_diagnostics#show()<CR>
  nnoremap <buffer> <Space>d :LspDocumentDiagnostic<CR><C-w>p
  nnoremap <buffer> <C-x><C-l> :LspNextError<CR>
  nnoremap <buffer> <C-x><C-x> :ResetLsp<CR>

  inoremap <buffer> <expr><C-p> <SID>lsp_scroll(-2, "\<Up>")
	inoremap <buffer> <expr><C-n> <SID>lsp_scroll(+2, "\<Down>")
  inoremap <buffer> <expr><C-c> <SID>close_popup()

  " to skip plugin's keybinding
  map <silent> <buffer> <C-c> <Plug>(lsp-float-close)


  " どこかで上書きされる？
  if g:colors_name == "newspaper"
    hi SignColumn guibg=#cccfbf
  else
    hi SignColumn guibg=black
  endif
endfunction

function! s:lsp_definition()
  :call feedkeys("\<C-c>")
  :LspDefinition
endfunction

let s:vs_vim_window = vital#lsp#import('VS.Vim.Window')
function! s:lsp_scroll(count, key)
  if pumvisible()
    return key
  endif
  let list = s:vs_vim_window.find({ winid -> s:vs_vim_window.is_floating(winid)})
  if len(list) != 0
    return lsp#scroll(a:count)
  end

  return a:key
endfunction

function! s:close_popup()
  call lsp#ui#vim#output#closepreview()
  return "\<Ignore>"
endfunction

function! s:reset_lsp()
  let b:my_lsp_buffer_enabled = 0
  for server in lsp#get_allowed_servers()
    try
      call lsp#stop_server(server)
      call timer_start(300, { t -> execute(":edit %")})
      echo "reset lsp : " . server
    catch 
      echomsg 'error occurred:' . v:exception
    endtry
  endfor
endfunction

augroup LspCommonGroup
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

