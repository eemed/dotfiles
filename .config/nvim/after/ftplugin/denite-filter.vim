imap <silent><buffer> <C-g> <Plug>(denite_filter_quit)
inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
inoremap <silent><buffer><expr> <tab> denite#do_map('choose_action')
inoremap <silent><buffer><expr> <c-t> denite#do_map('do_action', 'tabopen')
inoremap <silent><buffer><expr> <c-v> denite#do_map('do_action', 'vsplit')
inoremap <silent><buffer><expr> <c-h> denite#do_map('do_action', 'split')
inoremap <silent><buffer><expr> <c-o> denite#do_map('do_action', 'drop')
inoremap <silent><buffer><expr> <esc> denite#do_map('quit')
" for compatibility with FZF
inoremap <silent><buffer> <C-n> <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
inoremap <silent><buffer> <C-p> <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
" easier than n/p
inoremap <silent><buffer> <C-r> <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
inoremap <silent><buffer> <C-s> <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
