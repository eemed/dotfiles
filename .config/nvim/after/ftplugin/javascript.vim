compiler eslint
let b:formatcmd = "npx prettier " . shellescape(expand('%'))
nnoremap <buffer> <localleader>f :Format<cr>

setlocal suffixesadd+=.js,.jsx
