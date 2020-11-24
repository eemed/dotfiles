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

    let pattern = escape(join(keys(s:pairs) + values(s:pairs), '|'), '|[]')
    let line = getline(".")

    while !exists("matchpos") || matchpos != -1
        if !exists("matchpos")
            let matchpos = -1
        endif
        let matched = matchstrpos(line, pattern, matchpos + 1)
        let start = matched[0]
        let matchpos = matched[1]

        if has_key(s:pairs, start)
            let result = s:pairs[start] . result
        elseif index(values(s:pairs), start) != -1
            let result = result[1:]
        endif
    endwhile

    if result != ""
        return "\<CR>" . result . "\<c-o>O"
    endif
endfunction

function! s:TagCR() abort
    let col = col('.')
    let line = getline('.')
    let next_two = line[col - 1 : col]
    if next_two ==# "</" && line =~ '^\s*<\(.*\)\+><\/\1>$'
        return "\<CR>\<c-o>O"
    endif
endfunction

let g:blocks = {
      \   'begin': { 
      \     'start': '^\s*\\begin{\zs.*\ze}'
      \     'end': '\end{}'
      \   }
      \ }

function! s:CompleteBlock() abort
  let matched = matchstr(getline('.'), '^\s*\\begin{\zs.*\ze}')
  if matched != ""
    return "\<CR>\\end{" . matched . "}\<c-o>O"
  endif
endfunction

function! CustomCR() abort
    if &buftype ==# "quickfix" || &buftype ==# "nofile"
        return "\<CR>"
    endif

    let ret = <sid>CompleteBlock()
    if ret != ""
      return ret
    endif

    let ret = <sid>TagCR()
    if ret != ""
      return ret
    endif

    let ret = <sid>CloseBracket()
    if ret != ""
      return ret
    endif

    return "\<CR>"
endfunction
