let s:terminal_info = {
      \ 'last_cmd': "",
      \ 'focus': v:false,
      \ 'completion': []
      \ }
let s:terminal_complete_commands_keep = 20
function! s:TerminalRun(split, ... ) abort
  let cmd = a:1

  if cmd == ""
    let cmd = s:terminal_info.last_cmd
  endif

  if cmd == ""
    echo '[Term] No command to run.'
    return
  endif

  execute a:split
  execute 'terminal ' . cmd
  normal! G

  if s:terminal_info.focus == v:false
    let s:terminal_info.last_cmd = cmd
  endif

  if len(s:terminal_info.completion) == s:terminal_complete_commands_keep
    let s:terminal_info.completion = s:terminal_info.completion[:-2]
  endif

  if index(s:terminal_info.completion, cmd) == -1
    let s:terminal_info.completion = [cmd] + s:terminal_info.completion
  else
    call filter(s:terminal_info.completion, 'v:val !~ cmd')
    let s:terminal_info.completion = [cmd] + s:terminal_info.completion
  endif

  wincmd p
endfunction

function! s:TermComplete(ArgLead, CmdLine, CursorPos) abort
  return filter(copy(s:terminal_info.completion), 'match(v:val, a:ArgLead) == 0')
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<q-args>)
command! -nargs=0 TermMake call <sid>TerminalRun('split', &makeprg)
command! -nargs=1 TermFocus let s:terminal_info.focus = v:true
      \ | let s:terminal_info.last_cmd = <q-args>
      \ | call <sid>TerminalRun('split', s:terminal_info.last_cmd)
command! -nargs=0 TermReset let s:terminal_info.focus = v:false
command! -nargs=? -complete=customlist,<sid>TermComplete Term
      \ call <sid>TerminalRun('split', <q-args>)
command! -nargs=? VTerm call <sid>TerminalRun('vsplit', <q-args>)
command! -nargs=? TTerm call <sid>TerminalRun('tabnew', <q-args>)

command! -nargs=0 TermInfo :echo '[Term] Last command: "' . s:terminal_info.last_cmd .
      \ '", Focus: ' . s:terminal_info.focus
