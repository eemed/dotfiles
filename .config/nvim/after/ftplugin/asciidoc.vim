set makeprg=asciidoctor\ %\ -r\ asciidoctor-diagram\ -r\ asciidoctor-pdf\ -b\ pdf
command! -nargs=0 Open execute ':silent ! gio open %:r.pdf'
nnoremap <localleader>o :Open<cr>
setlocal wrap
setlocal synmaxcol=0
setlocal commentstring=//\ %s
