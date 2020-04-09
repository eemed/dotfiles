let &makeprg="pdflatex -halt-on-error " . shellescape(expand('%'))
command! -buffer -nargs=0 Open silent !gio open %:p:r.pdf
setlocal wrap spell
