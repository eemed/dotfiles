" Run &makeprg on filesave
let s:makeonsave = []

function! ToggleMakeOnSaveFT() abort
    if index(s:makeonsave, &filetype) >= 0
        call remove(s:makeonsave, &filetype)
        echom '[MakeOnSave] off'
    else
        if &filetype != ''
            call add(s:makeonsave, &filetype)
            echom '[MakeOnSave] on'
        else
            echom '[MakeOnSave] invalid filetype'
        endif
    endif
endfunction

function! s:MakeOnSaveFT() abort
    if index(s:makeonsave, &filetype) >= 0
        normal! mm
        silent make
        normal! `m
    endif
endfunction

augroup MakeOnSave
    autocmd!
    autocmd BufWritePost * call <sid>MakeOnSaveFT()
augroup end
