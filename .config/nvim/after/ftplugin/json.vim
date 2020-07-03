setlocal shiftwidth=2
setlocal tabstop=2
let b:formatcmd = 'python -m json.tool ' . shellescape(expand('%'))
