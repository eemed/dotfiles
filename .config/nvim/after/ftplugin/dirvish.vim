silent! unmap <buffer> <C-p>
silent! unmap <buffer> <C-n>
nnoremap <buffer> <localleader>mv :!mv <c-r>=expand('<cWORD>')<cr> <c-r>%
nnoremap <buffer> <localleader>mk :!mkdir -p <c-r>%
nnoremap <buffer> <localleader>rm :!rm -rf <c-r>=expand('<cWORD>')<cr>
nnoremap <buffer> <localleader>cp :!cp -r <c-r>=expand('<cWORD>')<cr> <c-r>%
nnoremap <buffer> <localleader>e :e <c-r>%

setlocal signcolumn=no
