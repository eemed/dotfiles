silent! unmap <buffer> <C-p>
silent! unmap <buffer> <C-n>
nnoremap <buffer> !m :Shdo mv {} <cr>A
nnoremap <buffer> !r :Shdo rm -rf {}<cr>
nnoremap <buffer> !c :Shdo cp -r {} <cr>A
nnoremap <buffer> !e :e %:p

setlocal signcolumn=no
