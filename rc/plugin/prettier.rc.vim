" https://prettier.io/docs/en/options.html

let g:prettier#config#trailing_comma = 'es5'
let g:prettier#config#arrow_parens = 'always'

let g:prettier#autoformat = 1
let g:prettier#quickfix_enabled = 0

command! AutoFormatEnabled :call s:autofomrat_enabled()
command! AutoFormatDisabled :call s:autofomrat_disabled()


let s:auto_format = 0

function! s:autofomrat_enabled()
  let s:auto_format = 1
endfunction
function! s:autofomrat_disabled()
  let s:auto_format = 0
endfunction
function! s:format()
  if s:auto_format
    PrettierAsync
  end
endfunction
augroup JsPrettier
 au!
 autocmd BufWritePre * call s:format()
augroup END
