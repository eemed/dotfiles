set expandtab
set shiftwidth=2
set tabstop=2

let b:formatcmd = "xmllint --format " . shellescape(expand('%'))
nnoremap <buffer> <localleader>f :Format<cr>
