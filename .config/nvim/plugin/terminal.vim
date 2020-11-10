let  s:runner_bufnr = -1

function! s:TermFinished(job_id, data, event) dict
  let s:runner_bufnr = -1
endfunction

function! s:TerminalOpen() abort
  if s:runner_bufnr == -1
    botright 15split
    enew
    call termopen(&shell, {
          \ 'on_exit': function('s:TermFinished'),
          \ 'buffer': bufnr()
          \ })
    let s:runner_bufnr = bufnr()
  else
    execute 'botright 15split | buffer ' . s:runner_bufnr
  endif
  startinsert!
endfunction

function! s:TerminalClose() abort
  if s:runner_bufnr != -1
    let cur_bufnr = bufnr()
    execute 'buffer ' . s:runner_bufnr
    close
    if cur_bufnr != s:runner_bufnr
      execute 'buffer ' . cur_bufnr
    endif
  endif
endfunction

function! s:TerminalToggle() abort
  if bufwinnr(s:runner_bufnr) == -1
    call <sid>TerminalOpen()
  else
    call <sid>TerminalClose()
  endif
endfunction

command! -nargs=0 TermToggle call <sid>TerminalToggle()

nnoremap <A-=> :TermToggle<cr>
tnoremap <A-=> <c-\><c-n>:TermToggle<cr>
