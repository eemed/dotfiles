let s:terminal_info = {
      \ 'last_cmd': "",
      \ 'focus': v:false,
      \ 'completion': []
      \ }
let s:terminal_complete_commands_keep = 20
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

  if len(s:terminal_info.completion) == s:terminal_complete_commands_keep
    let s:terminal_info.completion = s:terminal_info.completion[:-2]
  endif

  if index(s:terminal_info.completion, cmd) != -1
    call filter(s:terminal_info.completion, 'v:val !=# cmd')
  endif
  let s:terminal_info.completion = [cmd] + s:terminal_info.completion
endfunction

function! s:TermComplete(ArgLead, CmdLine, CursorPos) abort
  let splits = split(a:CmdLine, ' ')
  let arg = join(splits[1:], ' ')

  let result = copy(s:terminal_info.completion)
  call filter(result, 'match(v:val, arg) == 0')

  let cmd_cur_pos = a:CursorPos - len(splits[0]) - 1
  call map(result, {idx, val -> val[cmd_cur_pos:] })

  call filter(result, 'v:val != ""')

  return result
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
command! -nargs=? -complete=customlist,<sid>TermComplete Term
      \ call <sid>TerminalRun('split', <q-args>)
command! -nargs=? VTerm call <sid>TerminalRun('vsplit', <q-args>)
command! -nargs=? TTerm call <sid>TerminalRun('tabnew', <q-args>)

command! -nargs=0 TermInfo :echo '[Term] Last command: "' . s:terminal_info.last_cmd .
      \ '", Focus: ' . s:terminal_info.focus
