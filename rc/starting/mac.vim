" starting for mac

" フォント
set guifont=Osaka-Mono:h14
" 透明度
if g:colors_name == 'solarized'
else
"set transparency=5
endif
" esc 時に ime off mac vim only
"set imda
" ウインドウ幅
if &columns == 80
  set columns=95
endif
" ウインドウの高さ
set lines=37
