silent! unmap <buffer> <C-p>
silent! unmap <buffer> <C-n>
nnoremap <buffer> !mv :!mv <c-r>=expand('<cWORD>')<cr> <c-r>%
nnoremap <buffer> !mk :!mkdir -p <c-r>%
nnoremap <buffer> !rm :!rm -rf <c-r>=expand('<cWORD>')<cr>
nnoremap <buffer> !cp :!cp -r <c-r>=expand('<cWORD>')<cr> <c-r>%
nnoremap <buffer> !e :e <c-r>%

setlocal signcolumn=no

nnoremap <silent> <buffer> s :<c-u>call DirvishShowStats()<cr>
nmap <buffer> r R

if !exists('*DirvishShowStats')
  function DirvishShowStats() abort
    let line = getline('.')
    if isdirectory(line) || filereadable(line)
      let view = winsaveview()
      silent %norm! I'
      silent %norm! A'
      silent %!xargs stat --printf='\%.19y\t\%a\t\%U:\%G\t\%n\n'
      execute 'silent %s/\V' . escape(expand("%"), '/\') . '//g'
      call winrestview(view)
    endif
  endfunction
endif
