compiler eslint
let b:formatcmd = "npx prettier " . shellescape(expand('%'))
setlocal suffixesadd+=.js,.jsx
