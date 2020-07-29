command! -nargs=? -bang -complete=shellcmd Tmux call s:TmuxRun(<bang>0, <q-args>)
command! -nargs=1 -bang -complete=shellcmd TmuxFocus call s:TmuxFocus(<bang>0, <q-args>)
command! -nargs=0 TmuxStatus echo '[Tmux] Last command: "' . s:tmux_last_cmd .
            \ '", Focus: ' . s:tmux_focus
noremap <unique> <script> <silent> <Plug>TmuxMotionSend :<c-u>set opfunc=TmuxOp<cr>g@
noremap <unique> <script> <silent> <Plug>TmuxVisualSend :<c-u>call TmuxOp(visualmode(), 1)<cr>

if get(g:, 'tmux_split_orientation', '') == ''
    let g:tmux_split_orientation = 'v'
endif

if get(g:, 'tmux_split_size', '') == ''
    let g:tmux_split_size = 30
endif

if get(g:, 'tmux_command', '') == ''
    let g:tmux_command = 'tmux'
endif

let s:tmux_last_cmd = ""
let s:tmux_focus = v:false
let s:tmux_runner_index = -1

function! s:TmuxFocus(bang, command) abort
    if a:bang
        let s:tmux_focus = v:false
    else
        let s:tmux_focus = v:true
        let s:tmux_last_cmd = a:command
        call s:TmuxRun(0, '')
    endif
endfunction

function! s:TmuxRun(bang, cmd) abort
    if match(s:TmuxCommand('list-panes -a'), s:tmux_runner_index . ':') == -1
        call s:TmuxOpenRunner()
    endif

    let cmd = a:cmd

    if cmd == ''
        let cmd = s:tmux_last_cmd
    endif

    if cmd == ''
        call s:TmuxError('Invalid command')
        return
    endif

    if a:bang
        " Clear terminal
        call s:TmuxSendKeys('^L')
        call s:TmuxCommand('clear-history -t ' . s:tmux_runner_index)
    endif

    call s:TmuxSendText(cmd)
    call s:TmuxSendKeys("Enter")

    if !s:tmux_focus
        let s:tmux_last_cmd = cmd
    endif
endfunction

function! s:TmuxError(errormsg) abort
    echohl Error
    echo '[Tmux] ' . a:errormsg
    echohl None
endfunction

function! s:TmuxSendText(text) abort
  call s:TmuxSendKeys('"' . escape(a:text, '\"$`') . '"')
endfunction

function! s:TmuxSendKeys(keys) abort
    if match(s:TmuxCommand('list-panes -a'), s:tmux_runner_index . ':') != -1
        call s:TmuxCommand('send-keys -t ' . s:tmux_runner_index . ' ' . a:keys)
    else
        call s:TmuxError('No runner open')
    endif
endfunction

function! s:TmuxOpenRunner() abort
    let nearest = s:TmuxNearestIndex()
    if nearest != -1
        let s:tmux_runner_index = nearest
    else
        call <sid>TmuxCommand('split-window -p ' . g:tmux_split_size .
                    \ ' -' . g:tmux_split_orientation)
        let s:tmux_runner_index = s:TmuxIndex()
        call <sid>TmuxCommand('last-pane')
    endif
endfunction

function s:TmuxIndex() abort
    return substitute(s:TmuxCommand("display -p '#I.#P'"), '\n$', '', '')
endfunction

function! s:TmuxNearestIndex() abort
  let views = split(s:TmuxCommand("list-panes"), "\n")

  for view in views
    if match(view, "(active)") == -1
      return split(view, ":")[0]
    endif
  endfor

  return -1
endfunction

function! s:TmuxCommand(args) abort
    return system(g:tmux_command . ' ' . a:args)
endfunction

function! TmuxOp(type, ...) abort
    let view = winsaveview()

    let sel_save = &selection
    let &selection = 'inclusive'

    let rv = getreg('"')
    let rt = getregtype('"')

    if a:0  " Invoked from Visual mode, use '< and '> marks.
        silent exe "normal! `<" . a:type . '`>y'
    elseif a:type == 'line'
        silent exe "normal! '[V']y"
    elseif a:type == 'block'
        silent exe "normal! `[\<C-V>`]\y"
    else
        silent exe "normal! `[v`]y"
    endif

    call setreg('"', @", 'V')

    if match(s:TmuxCommand('list-panes -a'), s:tmux_runner_index . ':') == -1
        call s:TmuxOpenRunner()
    endif
    call s:TmuxSendText(@")

    let &selection = sel_save
    call setreg('"', rv, rt)

    call winrestview(view)
endfunction
