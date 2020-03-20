set makeprg=asciidoctor\ %\ -D\ ~/.asciidoc\ -r\ asciidoctor-diagram\ -r\ asciidoctor-pdf\ -b\ pdf
command! -nargs=0 Open execute ':silent ! gio open ~/.asciidoc/%:r.pdf'
