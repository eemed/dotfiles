" Scratch buffer
function! s:Scratch()
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    file scratch
endfunction
command! -nargs=0 Scratch call s:Scratch()
