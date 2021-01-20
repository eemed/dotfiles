let &l:define='^\s*\(def\|class\)\s*'
nnoremap `<cr> :TermRun python3 %<cr>

let s:top_level='^\(def\|class\)\s*'
nnoremap <silent> [[ m`:call search(s:top_level, 'bW')<cr>
nnoremap <silent> ]] m`:call search(s:top_level, "W")<CR>
