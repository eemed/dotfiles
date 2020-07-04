" Run &makeprg on filesave
let s:makeonsave = []
function! ToggleMakeOnSaveFT() abort
  let filetype = s:GetFiletype()

  if get(s:makeonsave, filetype, '') == filetype
    call remove(s:makeonsave, filetype)
    echom '[MakeOnSave] off'
  else
    call add(s:makeonsave, filetype)
    echom '[MakeOnSave] on'
  endif
endfunction

function! s:GetFiletype() abort
  let filetype = &ft
  if filetype == ""
    let filetype = "empty"
  endif
  return filetype
endfunction

function! s:MakeOnSaveFT() abort
  let filetype = s:GetFiletype()
  if get(s:makeonsave, filetype, '') == filetype
    normal! mm
    silent make
    normal! `m
  endif
endfunction

augroup MakeOnSave
  autocmd!
  autocmd BufWritePost * call <sid>MakeOnSaveFT()
augroup end
command! -nargs=0 ToggleMakeOnSaveFT call ToggleMakeOnSaveFT()
