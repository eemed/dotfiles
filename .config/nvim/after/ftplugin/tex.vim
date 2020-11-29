setlocal makeprg=latexmk\ -pdf\ -halt-on-error\ %
command! -buffer -nargs=0 Open silent !gio open %:p:r.pdf
setlocal wrap
set synmaxcol=0

" vimtex + vimcompletes me
let b:vcm_omni_pattern = g:vimtex#re#neocomplete
