setlocal makeprg=pandoc\ %\ -f\ markdown\ -t\ latex\ -o\ %:r.pdf
command! -nargs=0 Open execute ':silent ! gio open %:r.pdf'
setlocal wrap
" setlocal spell spelllang=en_us
