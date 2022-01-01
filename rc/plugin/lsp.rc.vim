
let g:lsp_log_file = ""
let g:lsp_preview_doubletap = 0
let g:lsp_preview_max_height = 2
"let g:lsp_diagnostics_enabled = 0

" メソッドのコメントを補完時にポップアップ表示する
let g:lsp_documentation_float=0

function! Apply_lsp_common_settings()
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes

  nnoremap <buffer> gd :LspDefinition<CR>
  nnoremap <buffer> <C-k> :LspDefinition<CR>
  nnoremap <buffer> K :LspHover<CR>
  nnoremap <buffer> <Leader>r :LspRename<CR>
  nnoremap <buffer> <C-x><C-f> :LspDocumentFormat<CR>
  nnoremap <buffer> <C-x><C-d> :LspDocumentDiagnostic<CR>
  nnoremap <buffer> <C-x><C-l> :LspNextError<CR>

  inoremap <buffer> <expr><C-p> <SID>lsp_scroll(-2, "\<Up>")
	inoremap <buffer> <expr><C-n> <SID>lsp_scroll(+2, "\<Down>")
  inoremap <buffer> <expr><C-c> <SID>close_popup()

  " どこかで上書きされる？
  if g:colors_name == "newspaper"
    hi SignColumn guibg=#cccfbf
  else
    hi SignColumn guibg=black
  endif
endfunction

function! s:lsp_scroll(count, key)
  let w = vital#lsp#import('VS.Vim.Window')
  let list = w.find({ winid -> w.is_floating(winid)})
  if len(list) != 0
    return lsp#scroll(a:count)
  end

  return a:key
endfunction

function! s:close_popup()
  call lsp#ui#vim#output#closepreview()
  return "\<Ignore>"
endfunction


augroup LspCommonGroup
  au!
  autocmd FileType vue call Apply_lsp_common_settings()
augroup END
