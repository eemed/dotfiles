set expandtab
set shiftwidth=4
set tabstop=4

let b:formatcmd = "XMLLINT_INDENT='    ' xmllint --format " . shellescape(expand('%'))
nnoremap <buffer> <leader>f :Format<cr>
