" let s:pairs = {
"             \ '{': '}',
"             \ '[': ']',
"             \ '(': ')',
"             \ }

" function! s:CloseBracket() abort
"     if len(getline('.')) != col('.') - 1
"         return "\<CR>"
"     endif

"     let result = ""

"     let pattern = escape(join(keys(s:pairs) + values(s:pairs), '|'), '|[]')
"     let line = getline(".")

"     while !exists("matchpos") || matchpos != -1
"         if !exists("matchpos")
"             let matchpos = -1
"         endif
"         let matched = matchstrpos(line, pattern, matchpos + 1)
"         let start = matched[0]
"         let matchpos = matched[1]

"         if has_key(s:pairs, start)
"             let result = s:pairs[start] . result
"         elseif index(values(s:pairs), start) != -1
"             let result = result[1:]
"         endif
"     endwhile

"     if result != ""
"         return "\<CR>" . result . "\<c-o>O"
"     endif
" endfunction

" function! s:TagCR() abort
"     let col = col('.')
"     let line = getline('.')
"     let next_two = line[col - 1 : col]
"     if next_two ==# "</" && line =~ '^\s*<\(.*\)\+><\/\1>$'
"         return "\<CR>\<c-o>O"
"     endif
" endfunction

" function! CustomCR() abort
"     if &buftype ==# "quickfix" || &buftype ==# "nofile"
"         return "\<CR>"
"     endif

"     let ret = <sid>TagCR()
"     if ret != ""
"       return ret
"     endif

"     let ret = <sid>CloseBracket()
"     if ret != ""
"       return ret
"     endif

"     return "\<CR>"
" endfunction

" " =================
"
let s:pairs = {
            \ '{': '}',
            \ '[': ']',
            \ '(': ')',
            \ }

function! s:CloseBracket(line) abort
    let result = ""

    let pattern = escape(join(keys(s:pairs) + values(s:pairs), '|'), '|[]')

    while !exists("matchpos") || matchpos != -1
        if !exists("matchpos")
            let matchpos = -1
        endif
        let matched = matchstrpos(a:line, pattern, matchpos + 1)
        let start = matched[0]
        let matchpos = matched[1]

        if has_key(s:pairs, start)
            let result = s:pairs[start] . result
        elseif index(values(s:pairs), start) != -1
            let result = result[1:]
        endif
    endwhile

    return result
endfunction

let g:smart_cr_chain = [
      " \ {
      " \   'regex': '^\s*<\zs.*\ze>$',
      " \   'callback': { m -> "</" . m . ">" }
      " \ },
      \ {
      \   'regex': '^.*[(\[{]\+$',
      \   'callback': function('s:CloseBracket')
      \ },
      " \ {
      " \   'regex': '^\s*\\begin{\zs.*\ze}',
      " \   'callback': { m -> "\\end{" . m . "}" }
      " \ }
      \ ]

function! SmartCR() abort
    if &buftype ==# "quickfix" || &buftype ==# "nofile"
        return "\<CR>"
    endif

    if exists('b:smart_cr_chain')
      let chain = b:smart_cr_chain + g:smart_cr_chain
    else
      let chain = g:smart_cr_chain
    endif

    let line = getline('.')
    for item in chain
      let match_str = matchstr(line, item.regex)
      if match_str != ""
        return "\<CR>" . item.callback(match_str) . "\<c-o>O"
      endif
    endfor
    return "\<CR>"
endfunction

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-r>=SmartCR()\<cr>"
