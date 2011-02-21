
function! neocomplcache#compare_len(i1, i2)
  let l:diff = len(a:i1.word) - len(a:i2.word)
  if !l:diff
    let l:diff = (a:i1.word ># a:i2.word) ? 1 : -1
  endif
  return l:diff
endfunction"}}}

function! neocomplcache#compare_rank_only(i1, i2)
  return a:i2.rank - a:i1.rank
endfunction"}}}

function! neocomplcache#integrate_completion(complete_result, is_sort)"{{{
  if empty(a:complete_result)
    if neocomplcache#get_cur_text() =~ '\s\+$'
          \ && neocomplcache#is_buffer_complete_enabled()
      " Caching current cache line.
      call neocomplcache#sources#buffer_complete#caching_current_cache_line()
    endif

    return [-1, '', []]
  endif

  let l:cur_keyword_pos = col('.')
  for l:result in values(a:complete_result)
    if l:cur_keyword_pos > l:result.cur_keyword_pos
      let l:cur_keyword_pos = l:result.cur_keyword_pos
    endif
  endfor
  let l:cur_text = neocomplcache#get_cur_text()
  let l:cur_keyword_str = l:cur_text[l:cur_keyword_pos :]

  let l:frequencies = neocomplcache#is_buffer_complete_enabled() ?
        \ neocomplcache#sources#buffer_complete#get_frequencies() : {}

  " Append prefix.
  let l:complete_words = []
  for [l:complfunc_name, l:result] in items(a:complete_result)
    let l:result.complete_words = deepcopy(l:result.complete_words)
    if l:result.cur_keyword_pos > l:cur_keyword_pos
      let l:prefix = l:cur_keyword_str[: l:result.cur_keyword_pos - l:cur_keyword_pos - 1]

      for keyword in l:result.complete_words
        let keyword.word = l:prefix . keyword.word
      endfor
    endif

    let l:base_rank = neocomplcache#get_plugin_rank(l:complfunc_name)

    for l:keyword in l:result.complete_words
      let l:word = l:keyword.word
      if !has_key(l:keyword, 'rank')
        let l:keyword.rank = l:base_rank
      endif
      if has_key(l:frequencies, l:word)
        let l:keyword.rank = l:keyword.rank * l:frequencies[l:word]
      endif
    endfor

    let l:complete_words += s:remove_next_keyword(l:complfunc_name, l:result.complete_words)
  endfor

  " Sort.
  if !neocomplcache#is_eskk_enabled() && a:is_sort
    call sort(l:complete_words, 'neocomplcache#compare_rank')
  endif

  " Check dup and set icase.
  let l:dup_check = {}
  let l:words = []
  let l:icase = g:neocomplcache_enable_ignore_case &&
        \!(g:neocomplcache_enable_smart_case && l:cur_keyword_str =~ '\u')
  for keyword in l:complete_words
    if keyword.word != ''
          \&& (!has_key(l:dup_check, keyword.word))
"          \    || (has_key(keyword, 'dup') && keyword.dup))
      let l:dup_check[keyword.word] = 1

      let l:keyword.icase = l:icase

      "let l:keyword.word = substitute(l:keyword.word , ')' , '' , '')
      "let l:keyword.word = substitute(l:keyword.word , '(' , '' , '')
      if !has_key(l:keyword, 'abbr')
        let l:keyword.abbr = l:keyword.word
      endif

      call add(l:words, keyword)
    endif
  endfor
  let l:complete_words = l:words

  " 100個も補完候補が上がる事がほとんどないから意味ないよなぁ・・・
  call sort(l:complete_words, 'neocomplcache#compare_rank_only')

  if g:neocomplcache_max_list >= 0
    let l:complete_words = l:complete_words[: g:neocomplcache_max_list]
  endif

  call sort(l:complete_words, 'neocomplcache#compare_len')

  " Delimiter check.
  let l:filetype = neocomplcache#get_context_filetype()
  if has_key(g:neocomplcache_delimiter_patterns, l:filetype)"{{{
    for l:delimiter in g:neocomplcache_delimiter_patterns[l:filetype]
      " Count match.
      let l:delim_cnt = 0
      let l:matchend = matchend(l:cur_keyword_str, l:delimiter)
      while l:matchend >= 0
        let l:matchend = matchend(l:cur_keyword_str, l:delimiter, l:matchend)
        let l:delim_cnt += 1
      endwhile

      for l:keyword in l:complete_words
        let l:split_list = split(l:keyword.word, l:delimiter)
        if len(l:split_list) > 1
          let l:delimiter_sub = substitute(l:delimiter, '\\\([.^$]\)', '\1', 'g')
          let l:keyword.word = join(l:split_list[ : l:delim_cnt], l:delimiter_sub)
          let l:keyword.abbr = join(split(l:keyword.abbr, l:delimiter)[ : l:delim_cnt], l:delimiter_sub)

          if g:neocomplcache_max_keyword_width >= 0
                \ && len(l:keyword.abbr) > g:neocomplcache_max_keyword_width
            let l:keyword.abbr = substitute(l:keyword.abbr, '\(\h\)\w*'.l:delimiter, '\1'.l:delimiter_sub, 'g')
          endif
          if l:delim_cnt+1 < len(l:split_list)
            let l:keyword.abbr .= l:delimiter_sub . '~'
            let l:keyword.dup = 0

            if g:neocomplcache_enable_auto_delimiter
              let l:keyword.word .= l:delimiter_sub
            endif
          endif
        endif
      endfor
    endfor
  endif"}}}

  " Convert words.
  if neocomplcache#is_text_mode()"{{{
    if l:cur_keyword_str =~ '^\l\+$'
      for l:keyword in l:complete_words
        let l:keyword.word = tolower(l:keyword.word)
        let l:keyword.abbr = tolower(l:keyword.abbr)
      endfor
    elseif l:cur_keyword_str =~ '^\u\+$'
      for l:keyword in l:complete_words
        let l:keyword.word = toupper(l:keyword.word)
        let l:keyword.abbr = toupper(l:keyword.abbr)
      endfor
    elseif l:cur_keyword_str =~ '^\u\l\+$'
      for l:keyword in l:complete_words
        let l:keyword.word = toupper(l:keyword.word[0]).tolower(l:keyword.word[1:])
        let l:keyword.abbr = toupper(l:keyword.abbr[0]).tolower(l:keyword.abbr[1:])
      endfor
    endif
  endif"}}}

  if g:neocomplcache_max_keyword_width >= 0"{{{
    " Abbr check.
    let l:abbr_pattern = printf('%%.%ds..%%s', g:neocomplcache_max_keyword_width-15)
    for l:keyword in l:complete_words
      if len(l:keyword.abbr) > g:neocomplcache_max_keyword_width
        if l:keyword.abbr =~ '[^[:print:]]'
          " Multibyte string.
          let l:len = neocomplcache#util#wcswidth(l:keyword.abbr)

          if l:len > g:neocomplcache_max_keyword_width
            let l:keyword.abbr = neocomplcache#util#truncate(l:keyword.abbr, g:neocomplcache_max_keyword_width - 2) . '..'
          endif
        else
          let l:keyword.abbr = printf(l:abbr_pattern, l:keyword.abbr, l:keyword.abbr[-13:])
        endif
      endif
    endfor
  endif"}}}

  return [l:cur_keyword_pos, l:cur_keyword_str, l:complete_words]
endfunction"}}}

function! s:remove_next_keyword(plugin_name, list)"{{{
  let l:list = a:list
  " Remove next keyword."{{{
  if a:plugin_name  == 'filename_complete'
    let l:pattern = '^\%(' . neocomplcache#get_next_keyword_pattern('filename') . '\m\)'
  else
    let l:pattern = '^\%(' . neocomplcache#get_next_keyword_pattern() . '\m\)'
  endif

  let l:next_keyword_str = matchstr('a'.getline('.')[len(neocomplcache#get_cur_text()) :], l:pattern)[1:]
  if l:next_keyword_str != ''
    let l:next_keyword_str = substitute(escape(l:next_keyword_str, '~" \.^$*[]'), "'", "''", 'g').'$'

    " No ignorecase.
    let l:ignorecase_save = &ignorecase
    let &ignorecase = 0

    for r in l:list
      if r.word =~ l:next_keyword_str
        let r.word = r.word[: match(r.word, l:next_keyword_str)-1]
      endif
    endfor

    let &ignorecase = l:ignorecase_save
  endif"}}}

  return l:list
endfunction"}}}
