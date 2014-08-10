
set textwidth=0
set ambiwidth=double
"set number
set nu
set autoindent
set iminsert=0
set titlestring=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ \ %{fnamemodify(getcwd(),':~')}
set titlelen=200
set linespace=5
set antialias
set backupdir=~/.vim/backup
set backupskip=/tmp/*,/private/tmp/*
set directory=~/.vim/swp
set scrolloff=5
set wrap
set hlsearch
set smartindent
set timeout timeoutlen=300 ttimeoutlen=200
set shellslash
set incsearch
set laststatus=2
set history=1000
set noswapfile
set cursorline
if has('patch300')
  set breakindent
endif
set noundofile
"set statusline=%3l%3p%%\ \|\ %<%t\ %m%=%c\|%R%Y%{'\|'.(&fenc!=''?&fenc:&enc).'\|'.&ff}
"set statusline=%3l%4p%%\ \|\ %t\ %<\ %m\ %r%=%{MyStatusPath()}\ \|\ %3c\ \|\ %Y\ 
set statusline=\ %Y\ \|\ %t\ %<\ %m\ %r%=%{MyStatusPath()}\ \|\ %3c\ \|\%3p%%\ 

function! MyStatusPath()
  if exists('b:my_status_path')
    return b:my_status_path
  endif
  let path  = expand("%:p:h")
  let gpath = finddir('.git', path . ';.;')

  if gpath == ''
    let gpath = findfile('Rakefile', path . ';')
  endif

  if gpath == ''
    let b:my_status_path = fnamemodify(path, ':~:h')
    return b:my_status_path
  endif

  if gpath == '.git' || gpath == 'Rakefile'
    let b:my_status_path = fnamemodify(path, ':t')
  else
    let gpath = fnamemodify(gpath, ':h:h') . '/'
    let b:my_status_path = substitute(path, gpath, '', '')
  endif

  return b:my_status_path
endfunction

" ubuntu だと画面がちらつく。mac だと音が出ちゃう。
if has('mac')
  "set vb t_vb=
  set vb
endif

set tabstop=2
set shiftwidth=2
set softtabstop=0
set expandtab
set noshowmatch
set matchpairs+=<:>
set shortmess=atTWIoO
set complete=.
set pumheight=10
set showcmd
set noshowmode
" 矩形選択中は行末にテキストがなくてもカーソルを行末以降に移動させることができる
set virtualedit+=block
set fileencodings=ucs-bom,utf-8,cp932,shift-jis,euc-jp
set fileformats=unix,dos

set ignorecase

" menu を無効
"let did_install_default_menus = 1
"let did_install_syntax_menu = 1
