augroup MyJuliaGroup
  autocmd!
  autocmd BufRead,BufNewFile *.jl  set filetype=julia
  autocmd FileType julia call Apply_lsp_common_settings()
augroup END

