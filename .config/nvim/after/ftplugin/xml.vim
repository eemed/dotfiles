set expandtab
set shiftwidth=4

let b:formatcmd = "XMLLINT_INDENT='    ' xmllint --format " . shellescape(expand('%'))
nnoremap <buffer> <leader>f :Format<cr>

let b:vcm_omni_pattern = "></"
