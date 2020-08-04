let &define = '^\s*function\(!\)\?\s*\(s:\)\?'
let b:section = '^"\s* Section:'
nnoremap <buffer> ]] m`:call search(b:section, "W")<CR>
nnoremap <buffer> [[ m`:call search(b:section, "bW")<CR>

set shiftwidth=2
set expandtab
