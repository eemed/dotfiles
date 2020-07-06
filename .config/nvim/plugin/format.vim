function! s:FormatFile() abort
  silent write
  if get(b:, 'formatcmd', '') == ''
    echo '[Format] no command set'
  else
    let l:view = winsaveview()
    let l:cmd = '%! ' . b:formatcmd
    silent execute l:cmd
    if v:shell_error > 0
      silent undo
      redraw
      echohl ErrorMsg
      echo '[Format] command "' . b:formatcmd . '" failed.'
      echohl None
      return v:shell_error
    endif
    call winrestview(l:view)
    echo '[Format] file formatted'
  endif
endfunction
command! -nargs=0 Format call <sid>FormatFile()
