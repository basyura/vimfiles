
if has('win64')
  let g:vimproc_dll_path = $HOME . '/.vim/proc/vimproc_win64.dll'
elseif has('win32')
  let g:vimproc_dll_path = $HOME . '/.vim/proc/proc_win.dll'
elseif has('win32unix')
  let g:vimproc_dll_path = $HOME . '/.vim/proc/proc_cygwin.dll'
else
  let g:vimproc_dll_path = $HOME . '/.vim/proc/proc_mac.so'
endif

