
if executable('typescript-language-server')
  augroup LspTypeScript
    au!
    autocmd User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), '.git/'))},
        \ 'whitelist': ['javascript.jsx', 'javascriptreact', 'typescript', 'typescript.tsx', 'typescriptreact', 'javascript'],
        \ })

    autocmd FileType typescript,typescriptreact,javascript,javascriptreact setlocal omnifunc=lsp#complete
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact setlocal signcolumn=yes
    autocmd FileType typescript,typescriptreact,javascript,javascriptreact  call s:settings()
  augroup END
endif

function! s:settings()
  call Apply_lsp_common_settings()

  nnoremap <buffer> <C-x><C-b> :LspDocumentDiagnostics<CR>
endfunction
