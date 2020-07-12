let s:pairs = {
            \ '{': '}',
            \ '[': ']',
            \ '(': ')',
            \ }

function! s:CloseBracket() abort
    if len(getline('.')) != col('.') - 1
        return "\<CR>"
    endif

    let result = ""

    let pattern = join(keys(s:pairs) + values(s:pairs), '\|')
    let line = getline(".")

    while !exists("matchpos") || matchpos != -1
        if !exists("matchpos")
            let matchpos = -1
        endif
        let matched = matchstrpos(line, pattern, matchpos + 1)
        let start = matched[0]
        let matchpos = matched[1]

        if has_key(s:pairs, start) && searchpair(start, '', s:pairs[start], 'n') == 0
            let result = s:pairs[start] . result
        elseif index(values(s:pairs), start) != -1
            let result = result[1:]
        endif
    endwhile

    if result != ""
        return "\<CR>" . result . "\<c-o>O"
    endif
    return "\<CR>"
endfunction

function! s:TagCR() abort
    let col = col('.')
    let next_two = getline(".")[col - 1 : col]
    if next_two ==# "</"
        return "\<CR>\<c-o>O"
    endif
    return "\<CR>"
endfunction

function! CustomCR() abort
    if &buftype ==# "quickfix" || 
                \ &buftype ==# "nofile"
        return "\<CR>"
    endif

    let previous = getline(".")[col('.') - 2]

    if previous == '>'
        return <sid>TagCR()
    endif

    return <sid>CloseBracket()
endfunction
