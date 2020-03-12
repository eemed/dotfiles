tnoremap <Esc> <C-c>
setlocal signcolumn=no
autocmd BufLeave <buffer> tnoremap <Esc> <C-\><C-n>
set laststatus=0 noshowmode noruler
autocmd BufLeave <buffer> set laststatus=2 showmode ruler
