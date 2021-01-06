let &define = '^\s*function\(!\)\?\s*\(s:\)\?'
let b:section = '^"\s* Section:'
nnoremap <silent> <buffer> ]] m`:call search(b:section, "W")<CR>
nnoremap <silent> <buffer> [[ m`:call search(b:section, "bW")<CR>

set shiftwidth=4
set expandtab
