tnoremap <buffer> <Esc> <C-c>
tnoremap <buffer> <tab> <c-n>
tnoremap <buffer> <s-tab> <c-p>
setlocal signcolumn=no
autocmd BufLeave <buffer> tnoremap <Esc> <C-\><C-n>
set laststatus=0 noshowmode noruler
autocmd BufLeave <buffer> set laststatus=2 showmode ruler
