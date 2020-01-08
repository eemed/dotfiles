nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
nnoremap <silent><buffer><expr> <tab> denite#do_map('choose_action')
nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
nnoremap <silent><buffer><expr> T denite#do_map('do_action', 'tabopen')
nnoremap <silent><buffer><expr> v denite#do_map('do_action', 'vsplit')
nnoremap <silent><buffer><expr> h denite#do_map('do_action', 'split')
nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
nnoremap <silent><buffer><expr> q denite#do_map('quit')
nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
nnoremap <nowait> <silent><buffer><expr> y denite#do_map('do_action', 'yank')
nnoremap <silent><buffer><expr> c denite#do_map('do_action', 'cd')
nnoremap <silent><buffer><expr> e denite#do_map('do_action', 'edit')
nnoremap <nowait> <silent><buffer><expr> o denite#do_map('do_action', 'drop')
nnoremap <silent><buffer><expr> V denite#do_map('toggle_select')
nnoremap <silent><buffer><expr> <space> denite#do_map('toggle_select').'j'

" I am not sure how to remap this now, previous denite functions are gone
nnoremap <silent><buffer> s j
nnoremap <silent><buffer> r k
