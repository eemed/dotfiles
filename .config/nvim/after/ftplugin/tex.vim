set makeprg=latexmk\ -pdf\ -halt-on-error\ %
command! -buffer -nargs=0 Open silent !gio open %:p:r.pdf
nnoremap <localleader>o :Open<cr>
setlocal wrap spell
set colorcolumn&
set synmaxcol=0
