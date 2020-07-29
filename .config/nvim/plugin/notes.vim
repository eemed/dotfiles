" let g:notes_dir = '~/.vim_notes'

" function! s:Notes() abort
"     if !exists(expand(g:notes_dir))
"         call mkdir(g:notes_dir)
"     endif
"     execute 'edit ' . g:notes_dir . '/index.md'
" endfunction
" command! -nargs=0 Scratch call <sid>Notes()
