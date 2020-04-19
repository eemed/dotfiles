set makeprg=asciidoctor\ %\ -r\ asciidoctor-diagram\ -r\ asciidoctor-pdf\ -b\ pdf
command! -nargs=0 Open execute ':silent ! gio open %:r.pdf'
setlocal wrap
set colorcolumn&

