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
      \   'regex': '^\s*<\zs.*\ze>$',
      \   'callback': { m -> "</" . m . ">" }
      \ }

augroup SmartCR
  autocmd!
  autocmd FileType vim let b:smart_cr_chain = [
        \ {
        \   'regex': '^\s*\zs\(if\|for\|while\|whil\|whi\|wh\|function\|functio\|functi\|funct\|func\|fun\|fu\)\ze',
        \   'callback': { m -> "end".m }
        \ },
        \ {
        \   'regex': '^\s*\zs\(augroup\|augrou\|augro\|augr\|aug\)\ze',
        \   'callback': { m -> m." end" }
        \ },
        \ ]

  autocmd FileType sh let b:smart_cr_chain = [
        \ {
        \   'regex': '^\s*\(if.*;\s*then$\|then$\)',
        \   'callback': { m -> "fi" }
        \ },
        \ {
        \   'regex': '^\s*\(do$\|while.*;\s*do$\|for.*;\s*do$\|until.*;\s*do$\)',
        \   'callback': { m -> "done" }
        \ },
        \ {
        \   'regex': '^\s*\(case.*in$\)',
        \   'callback': { m -> "esac" }
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
        \   'regex': '^\s*\\begin{\zs[a-zA-Z0-9]*\ze}',
        \   'callback': { m -> "\\end{" . m . "}" }
        \ },
        \ {
        \   'regex': '^\s*\\[$',
        \   'callback': { m -> "\\]" }
        \ },
        \ {
        \   'regex': '^\s*\\item',
        \   'callback': { m -> "\<CR>\\item " },
        \   'wrap': 0,
        \ },
        \ ]
augroup end

let g:smart_cr_chain = [
      \ {
      \   'regex': '^.*[(\[{]\+$',
      \   'callback': function('s:CloseBracket')
      \ },
      \ ]

function! SmartCR() abort
    let line = getline('.')

    if &buftype ==# "quickfix" || &buftype ==# "nofile" || col('.') != len(line) + 1
        return "\<CR>"
    endif

    if exists('b:smart_cr_chain')
      let chain = b:smart_cr_chain + g:smart_cr_chain
    else
      let chain = g:smart_cr_chain
    endif

    for item in chain
      let match_str = matchstr(line, item.regex)
      if match_str != ""
        if get(item, 'wrap', 1) == 1
          return "\<CR>" . item.callback(match_str) . "\<c-o>O"
        else
          return item.callback(match_str)
        endif
      endif
    endfor
    return "\<CR>"
endfunction

inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-r>=SmartCR()\<cr>"
