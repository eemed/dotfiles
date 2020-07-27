" compiler cargo
" setlocal makeprg=cargo\ check

" nnoremap <leader>f :RustFmt<cr>
" nnoremap <leader>r :RustRun<cr>
" nnoremap <localleader>t :RustTest<cr>

let method_pat = '^.*fn \ze\i\+(.*).*{'
nnoremap <silent> [m m':call search(method_pat, 'bW')<cr>
nnoremap <silent> ]m m':call search(method_pat, "W")<CR>
