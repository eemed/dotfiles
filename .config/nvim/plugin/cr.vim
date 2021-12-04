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

let s:smart_tags =  {
            \   'start_regex': '^\s*<\zs\S\+\ze.*>$',
            \   'end_func': { m -> "</" . m . ">" }
            \ }

augroup SmartCR
    autocmd!
    autocmd FileType vim let b:smart_cr_chain = [
                \ {
                \   'start_regex': '^\s*\zs\(if\|for\|while\|whil\|whi\|wh\|function\|functio\|functi\|funct\|func\|fun\|fu\)\ze',
                \   'end_func': { m -> "end".m }
                \ },
                \ {
                \   'start_regex': '^\s*\zs\(augroup\|augrou\|augro\|augr\|aug\)\ze',
                \   'end_func': { m -> m." end" }
                \ },
                \ ]

    autocmd FileType sh let b:smart_cr_chain = [
                \ {
                \   'start_regex': '^\s*\(if.*;\s*then$\|then$\)',
                \   'end_func': { m -> "fi" }
                \ },
                \ {
                \   'start_regex': '^\s*\(do$\|while.*;\s*do$\|for.*;\s*do$\|until.*;\s*do$\)',
                \   'end_func': { m -> "done" }
                \ },
                \ {
                \   'start_regex': '^\s*\(case.*in$\)',
                \   'end_func': { m -> "esac" }
                \ },
                \ ]

    autocmd FileType javascript,javascriptreact let b:smart_cr_chain = [
                \ s:smart_tags,
                \ ]

    autocmd FileType xml let b:smart_cr_chain = [
                \ s:smart_tags,
                \ ]

    autocmd FileType tex let b:smart_cr_chain = [
                \ {
                \   'start_regex': '^\s*\\begin{\zs[a-zA-Z0-9\*]*\ze}',
                \   'end_func': { m -> "\\end{" . m . "}" }
                \ },
                \ {
                \   'start_regex': '^\s*\\[$',
                \   'end_func': { m -> "\\]" }
                \ },
                \ {
                \   'start_regex': '^\s*\\item',
                \   'end_func': { m -> "\\item " },
                \   'append_lineup': 0,
                \ },
                \ ]
augroup end

let g:smart_cr_chain = [
            \ {
            \   'start_regex': '^.*[(\[{]\+$',
            \   'end_func': function('s:CloseBracket')
            \ },
            \ ]

function! SmartCR() abort
    let line_nr = line('.')
    let line = getline('.')

    if &buftype ==# "quickfix" || &buftype ==# "nofile" || col('.') != len(line) + 1
        return "\<CR>"
    endif

    let chain = []

    if exists('b:smart_cr_chain')
        let chain += b:smart_cr_chain
    endif

    if exists('g:smart_cr_chain')
        let chain += g:smart_cr_chain
    endif

    for item in chain
        let start_str = matchstr(line, item.start_regex)
        if start_str != ""
            let end_str = item.end_func(start_str)
            let result = "\<CR>" . end_str

            " By default append <c-o>O
            if get(item, 'append_lineup', 1) == 1
                return result . "\<c-o>O"
            endif

            return result
        endif
    endfor
    return "\<CR>"
endfunction

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-r>=SmartCR()\<cr>"
