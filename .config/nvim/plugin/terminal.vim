let s:terminal_info = {
      \ 'last_cmd': "",
      \ 'focus': v:false,
      \ }
let s:finished_buffers = []

function! s:TermFinished(job_id, data, event) dict
  call add(s:finished_buffers, self.buffer)
endfunction

function! s:TermClean() abort
  for buf in s:finished_buffers
    if bufexists(buf) && bufwinnr(buf) == -1
      silent execute 'bdelete! ' . buf
    endif
  endfor
endfunction

function! s:TerminalRun(split, ... ) abort
  call s:TermClean()
  let cmd = a:1

  if cmd == ""
    let cmd = s:terminal_info.last_cmd
  endif

  if cmd == ""
    echo '[Term] No command to run.'
    return
  endif

  execute a:split
  enew
  call termopen(cmd, {
        \ 'on_exit': function('s:TermFinished'),
        \ 'buffer': bufnr()
        \ })

  normal! G
  wincmd p

  if s:terminal_info.focus == v:false
    let s:terminal_info.last_cmd = cmd
  endif
endfunction

function! s:Focus(bang, ...) abort
  if a:bang
    let s:terminal_info.focus = v:false
  else
    let s:terminal_info.focus = v:true
    let s:terminal_info.last_cmd = a:1
    call <sid>TerminalRun('split', s:terminal_info.last_cmd)
  endif
endfunction

command! -nargs=0 TermMake call <sid>TerminalRun('split', &makeprg)
command! -nargs=? -bang TermFocus call <sid>Focus(<bang>0, <q-args>)
command! -nargs=? -complete=shellcmd Term
      \ call <sid>TerminalRun('split', <q-args>)
command! -nargs=? -complete=shellcmd VTerm call <sid>TerminalRun('vsplit', <q-args>)
command! -nargs=? -complete=shellcmd TTerm call <sid>TerminalRun('tabnew', <q-args>)

command! -nargs=0 TermInfo :echo '[Term] Last command: "' . s:terminal_info.last_cmd .
      \ '", Focus: ' . s:terminal_info.focus
