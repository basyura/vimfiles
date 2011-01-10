
" RankOrder."{{{
function! neocomplcache#compare_rank(i1, i2)
  let diff = a:i2.rank - a:i1.rank
  if diff == 0
    let diff = len(a:i1.word) - len(a:i2.word)
    if diff == 0
      return a:i1.word > a:i2.word ? 1 : -1
    endif
  endif
  return diff
endfunction"}}}
