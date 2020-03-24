set makeprg=make\ lint
command! -nargs=0 FormatJS execute 'silent !make fix'
nnoremap <buffer><f3> :FormatJS<cr>
