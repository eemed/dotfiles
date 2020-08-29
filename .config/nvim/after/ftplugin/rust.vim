compiler cargo
setlocal makeprg=cargo\ clippy

setlocal path+=src/**,

let method_pat = '^.*fn \ze\i\+(.*).*{'
nnoremap <silent> [m m':call search(method_pat, 'bW')<cr>
nnoremap <silent> ]m m':call search(method_pat, "W")<CR>
