setlocal makeprg=latexmk\ -pdf\ -halt-on-error\ %
command! -buffer -nargs=0 Open silent !gio open %:p:r.pdf
setlocal wrap
set synmaxcol=0
