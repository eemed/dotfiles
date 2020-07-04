" Scratch buffer
function! Scratch()
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    file scratch
endfunction
