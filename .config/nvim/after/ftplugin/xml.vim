set expandtab
set shiftwidth=4

if executable('xmllint')
  set formatprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
endif

let b:vcm_omni_pattern = "></"
