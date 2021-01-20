let s:runner_bufnr = -1

function! s:TermFinished(job_id, data, event) dict
  let s:runner_bufnr = -1
endfunction

function! s:TerminalOpen() abort
  if s:runner_bufnr == -1
    botright 15split
    enew
    set hidden
    let s:runner_bufnr = bufnr()
    call termopen(&shell, {
          \ 'on_exit': function('s:TermFinished'),
          \ 'buffer': s:runner_bufnr
          \ })
  else
    execute 'botright 15split | buffer ' . s:runner_bufnr
  endif
  startinsert!
endfunction

function! s:TerminalClose() abort
  if s:runner_bufnr != -1
    let cur_bufnr = bufnr()
    let winnr = bufwinnr(s:runner_bufnr)
    execute winnr . ' wincmd w'
    close
    let cur_winnr = bufwinnr(cur_bufnr)
    execute cur_winnr . ' wincmd w'
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
command! -nargs=? -bang TermRemember call <sid>TermRemember(<bang>0, <q-args>)

nnoremap <A-=> :TermToggle<cr>
tnoremap <A-=> <c-\><c-n>:TermToggle<cr>


" Runnning buffer specific commands

function! s:TermRemember(bang, cmd) abort
    if a:bang == 1
        let b:term_last_cmd = ''
    else
        let b:term_last_cmd = a:cmd
    endif
endfunction

function! s:TermRun(cmd) abort
    if a:cmd == '' && get(b:, 'term_last_cmd', '') == ''
        echohl ErrorMsg
        echo 'No command to run'
        echohl
        return
    endif

    15split
    if get(b:, 'term_last_cmd', '') != ''
        execute 'terminal ' . b:term_last_cmd
    else
        execute 'terminal ' . a:cmd
    endif
    startinsert!
endfunction

command! -nargs=? TermRun call <sid>TermRun(<q-args>)

nnoremap `<cr> :TermRun<cr>
nnoremap `<space> :TermRemember<space>
nnoremap `! :TermRemember!<cr>
nnoremap `? :echo 'Remember cmd: "' . get(b:, 'term_last_cmd', '') . '"'<cr>
