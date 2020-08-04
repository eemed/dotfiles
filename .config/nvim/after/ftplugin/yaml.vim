set expandtab
set shiftwidth=2

let top_level = '^- \S*: '
let any_level = '^\s*- \S*: '
nnoremap <silent> [[ m':call search(top_level, 'bW')<cr>
nnoremap <silent> ]] m':call search(top_level, "W")<CR>

nnoremap <silent> [m m':call search(any_level, 'bW')<cr>
nnoremap <silent> ]m m':call search(any_level, "W")<CR>

" Ansible
setlocal path+=roles/**
