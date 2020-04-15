setlocal makeprg=pandoc\ %\ -f\ markdown\ -t\ latex\ -o\ %:r.pdf
nnoremap <leader>o :silent exec "! gio open %:r.pdf"<CR>
setlocal wrap
" setlocal spell spelllang=en_us
set colorcolumn&
