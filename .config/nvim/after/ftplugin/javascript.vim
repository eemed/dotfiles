compiler eslint
let b:formatcmd = "npx prettier " . shellescape(expand('%'))

setlocal isfname+=@-@ " some node_modules are namespaced with an @
setlocal suffixesadd+=.js,.json,.jsx,.ts,.tsx
setlocal include=^\\s*[^\/]\\+\\(from\\\|require(\\)\\s*['\"\.]
let &l:define  = '^\s*\(\(export\s\)*\(default\s\)*\(function\)\s\|\(const\s*\ze\i\+\s*=\s*(.*)\s*=>\s*{\)\|\(\ze\i\+(.*)\s*{\)\)'

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
