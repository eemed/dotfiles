setlocal makeprg=pdflatex\ %
command! -buffer -nargs=0 Open silent !gio open %:p:r.pdf
setlocal wrap
setlocal spell
