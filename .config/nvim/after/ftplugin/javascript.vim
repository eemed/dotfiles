compiler eslint
let b:formatcmd = "npx prettier " . shellescape(expand('%'))

setlocal isfname+=@-@ " some node_modules are namespaced with an @
setlocal suffixesadd+=.js,.json,.jsx,.ts,.tsx
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(\\)\\s*['\"\.]
let define_pat  = '\(\(export\s\)\?\(default\s\)\?\(function\|class\)\s*\|\(const\s*\ze\i\+\s*=\s*(.*)\s*=>\)\|\(\ze\i\+(.*)\s*{\)\)'
let &l:define  = '^\s*' . define_pat

function! LoadMainNodeModule(fname)
    let nodeModules = "./node_modules/"
    let packageJsonPath = nodeModules . a:fname . "/package.json"

    if filereadable(packageJsonPath)
        return nodeModules . a:fname . "/" . json_decode(join(readfile(packageJsonPath))).main
    else
        return nodeModules . a:fname
    endif
endfunction

set includeexpr=LoadMainNodeModule(v:fname)

nnoremap <silent> [[ m':call search('^' . define_pat, 'bW')<cr>
nnoremap <silent> ]] m':call search('^' . define_pat, "W")<CR>

set shiftwidth=2
