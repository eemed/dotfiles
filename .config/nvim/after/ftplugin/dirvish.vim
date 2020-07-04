silent! unmap <buffer> <C-p>
silent! unmap <buffer> <C-n>
nnoremap <buffer> !mv :!mv <c-r>=expand('<cWORD>')<cr> <c-r>%
nnoremap <buffer> !mk :!mkdir -p <c-r>%
nnoremap <buffer> !rm :!rm -rf <c-r>=expand('<cWORD>')<cr>
nnoremap <buffer> !cp :!cp -r <c-r>=expand('<cWORD>')<cr> <c-r>%
nnoremap <buffer> !e :e <c-r>%

setlocal signcolumn=no
