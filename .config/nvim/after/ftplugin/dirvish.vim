silent! unmap <buffer> <C-p>
silent! unmap <buffer> <C-n>
nnoremap <buffer> <localleader>m :Shdo mv {} <cr>A
nnoremap <buffer> <localleader>d :!mkdir -p <c-r>%
nnoremap <buffer> <localleader>r :Shdo rm -rf {}<cr>
nnoremap <buffer> <localleader>c :Shdo cp -r {} <cr>A
nnoremap <buffer> <localleader>e :e <c-r>%

setlocal signcolumn=no
