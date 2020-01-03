set makeprg=asciidoctor\ %\ -D\ ~/.asciidoc\ -r\ asciidoctor-diagram\ -r\ asciidoctor-pdf\ -b\ pdf
nnoremap <leader>o :silent exec "! gio open ~/.asciidoc/%:r.pdf"<CR>
