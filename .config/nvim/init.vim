" Setup {{{
let g:vimdir = stdpath('config')
let g:python3_host_prog = '/usr/bin/python3'

" Install vim-plug
if empty(glob(g:vimdir . '/autoload/plug.vim'))
  execute 'silent !curl -fLo ' . g:vimdir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}
" Key mappings {{{
let mapleader = " "

nnoremap k gk
nnoremap j gj

" Window navigation
nnoremap <c-h> :wincmd h<cr>
nnoremap <c-j> :wincmd j<cr>
nnoremap <c-k> :wincmd k<cr>
nnoremap <c-l> :wincmd l<cr>

imap <c-h> <c-g>u<Esc>[s1z=`]a<c-g>u
" nmap <c-h> mm[s1z=`m

nnoremap Y y$

" Move text
xnoremap < <gv
xnoremap > >gv

nnoremap <leader>S :source <c-r>%<CR>
nnoremap <leader>q :q<cr>
nnoremap <BS> <C-^>

" Saving
nnoremap <silent><c-s> :update<CR>
inoremap <silent><c-s> <c-o>:update<CR>

" Too many mistakes
cabbrev W   w
cabbrev Q   q
cabbrev Qa  qa
cabbrev QA  qa
cabbrev Wq  wq
cabbrev WQ  wq
cabbrev Wqa wqa
cabbrev WQa wqa
cabbrev WQA wqa

function! StripWhitespace() abort
  let l:save = winsaveview()
  keeppatterns %s/\s\+$//e
  call winrestview(l:save)
endfunction
nnoremap <leader>s :call StripWhitespace()<cr>

for char in [ '$', '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
  execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
  execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
  execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
  execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" number text object (integer and float)
function! VisualNumber() abort
  call search('\d\([^0-9\.]\|$\)', 'cW')
  normal v
  call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call VisualNumber()<CR>
onoremap in :<C-u>normal vin<CR>

nnoremap m<cr> :make<cr>
nnoremap m? :set makeprg<cr>

nnoremap <silent> [m m':call search(&define, 'bW')<cr>
nnoremap <silent> ]m m':call search(&define, "W")<CR>

set pastetoggle=<F2>

" I need some finnish letters occasionally {{{
let g:fix_keys_enabled = 0
function! s:FixKeys() abort
  inoremap ; ö
  inoremap : Ö
  inoremap ' ä
  inoremap " Ä
  let g:fix_keys_enabled = 1
endfunction

function! s:RestoreKeys() abort
  if g:fix_keys_enabled == 1
    iunmap ;
    iunmap :
    iunmap '
    iunmap "
    let g:fix_keys_enabled = 0
  endif
endfunction
inoremap <silent> <c-b> <c-o>:call <sid>FixKeys()<cr>
augroup FinKeys
  autocmd!
  autocmd InsertLeave * call <sid>RestoreKeys()
augroup end
" }}}
" }}}
" Settings {{{
filetype plugin indent on
set hidden

" Splitting
set splitright splitbelow diffopt=vertical

set lazyredraw
set mouse=a
set nowrap
set list listchars=tab:→\ ,nbsp:•,trail:•
set breakindent
let &showbreak='↳ '
set include=
set keywordprg=
set nrformats+=alpha

set clipboard=unnamed,unnamedplus

" Commands without remembering case. Useful for plugin commands
set ignorecase smartcase

" Show replacement
set inccommand=split
set wildignore+=*/node_modules/*,*/__pycache__/,*/venv/*,*.pyc,.git/*,*.pdf

set smartindent
set hlsearch
nnoremap <esc> :let @/ = ""<cr><esc>

" Use undo files
set undofile
set nobackup
set nowritebackup
set noswapfile
let &undodir = g:vimdir . '/undo'
let &dir = g:vimdir . '/swap'
set viminfo='20

set updatetime=300
set foldmethod=marker

set scrolloff=5
set sidescrolloff=10

" Autocreate directories {{{
function! s:create_and_save_directory()
  let l:directory = expand('<afile>:p:h')
  if l:directory !~# '^\w\+:' && !isdirectory(l:directory)
    call mkdir(l:directory, 'p')
  endif
endfunction
" }}}
" Sane path with git{{{
function SetSanePath() abort
  " Set a basic &path
  set path=.,,

  " Check if inside git repository and retrieve current branch
  let l:branch = system('git rev-parse --abbrev-ref HEAD 2>/dev/null')
  if l:branch == ''
    return
  endif

  " Retrieve list of tracked directories
  let l:tree_command = "git ls-tree -d --name-only " . l:branch
  let l:git_directories = systemlist(l:tree_command . ' 2>/dev/null')
  if empty(l:git_directories)
    return
  endif

  " Remove dot directories
  let l:directories = filter(l:git_directories, { idx, val -> val !~ '^\.' })

  " Add recursive wildcard to each directory
  let l:final_directories = map(l:directories, { idx, val -> val . '/**' })

  " Add all directories to &path
  let &path .= join(l:final_directories, ',')
endfunction
call SetSanePath()

function! s:CD(path) abort
  execute 'cd ' . a:path
  call SetSanePath()
endfunction
command! -nargs=? -complete=dir CD :call s:CD(<q-args>)
cnoreabbrev <expr> cd getcmdtype() == ":" && getcmdline() == 'cd' ? 'CD' : 'cd'
" }}}
" Settings autocmds {{{
augroup Settings
  autocmd!
  " Quickfix settings
  autocmd WinEnter * if winnr('$') == 1 && &buftype == "quickfix"|q|endif
  autocmd QuickFixCmdPost [^l]* nested cwindow
  autocmd QuickFixCmdPost    l* nested lwindow

  " Autocreate dirs
  autocmd BufWritePre,FileWritePre * call <sid>create_and_save_directory()

  " Autosave
  autocmd FocusLost,BufLeave * silent! update
augroup end " }}}
" }}}
" Terminal {{{
tnoremap <esc> <c-\><c-n>
tnoremap <c-v> <c-\><c-n>pi

let g:terminal_info = {
      \ 'last_cmd': "",
      \ 'focus': v:false,
      \ 'completion': []
      \ }
let g:terminal_complete_commands_keep = 20
function! s:TerminalRun(split, ... ) abort
  let cmd = a:1

  if cmd == ""
    let cmd = g:terminal_info.last_cmd
  endif

  if cmd == ""
    echo '[Term] No command to run.'
    return
  endif

  execute a:split
  execute 'terminal ' . cmd

  if g:terminal_info.focus == v:false
    let g:terminal_info.last_cmd = cmd
  endif

  if len(g:terminal_info.completion) == g:terminal_complete_commands_keep
    let g:terminal_info.completion = g:terminal_info.completion[:-2]
  endif

  if index(g:terminal_info.completion, cmd) == -1
    let g:terminal_info.completion = [cmd] + g:terminal_info.completion
  else
    call filter(g:terminal_info.completion, 'v:val !~ cmd')
    let g:terminal_info.completion = [cmd] + g:terminal_info.completion
  endif

  wincmd p
endfunction

function! s:TermComplete(ArgLead, CmdLine, CursorPos) abort
  return filter(copy(g:terminal_info.completion), 'match(v:val, a:ArgLead) == 0')
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<q-args>)
command! -nargs=0 TermMake call <sid>TerminalRun('split', &makeprg)
command! -nargs=1 TermFocus let g:terminal_info.focus = v:true
      \ | let g:terminal_info.last_cmd = <q-args>
      \ | call <sid>TerminalRun('split', g:terminal_info.last_cmd)
command! -nargs=0 TermReset let g:terminal_info.focus = v:false
command! -nargs=? -complete=customlist,<sid>TermComplete Term
      \ call <sid>TerminalRun('split', <q-args>)
command! -nargs=? VTerm call <sid>TerminalRun('vsplit', <q-args>)
command! -nargs=? TTerm call <sid>TerminalRun('tabnew', <q-args>)
nnoremap `<space> :Term<space>
nnoremap `<cr> :Term<cr>
nnoremap `? :echo '[Term] Last command: "' . g:terminal_info.last_cmd .
      \ '", Focus: ' . g:terminal_info.focus<cr>
" }}}
" Completion {{{
set pumheight=10
set completeopt=noselect,menuone,menu
set omnifunc=syntaxcomplete#Complete

inoremap <c-l> <c-x><c-l>
inoremap <expr> / pumvisible() ? "\<c-y>\<c-x>\<c-f>" : "/"
" }}}
" Commands {{{
command! -nargs=0 Config execute ':edit ' . $MYVIMRC
nnoremap <leader>c :Config<CR>

command! -nargs=? -complete=filetype EditFileTypePlugin
      \ execute 'keepj vsplit ' . g:vimdir . '/after/ftplugin/' .
      \ (empty(<q-args>) ? &ft : <q-args>) . '.vim'

" Scratch buffer {{{
function! s:Scratch()
    noswapfile hide enew
    setlocal buftype=nofile
    setlocal bufhidden=hide
    file scratch
endfunction
command! -nargs=0 Scratch call <sid>Scratch()
" }}}
" Format {{{
function! s:FormatFile() abort
  write
  if get(b:, 'formatcmd', '') == ''
    echo '[Format] no command set'
  else
    let l:view = winsaveview()
    let l:cmd = '%! ' . b:formatcmd
    silent execute l:cmd
    if v:shell_error > 0
      silent undo
      redraw
      echohl ErrorMsg
      echo '[Format] command "' . b:formatcmd . '" failed.'
      echohl None
      return v:shell_error
    endif
    call winrestview(l:view)
    echo '[Format] file formatted'
  endif
endfunction
command! -nargs=0 Format call <sid>FormatFile()
" }}}
" Grep {{{
" https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
if executable('ag')
  set grepprg=ag\ --vimgrep\ --smart-case
endif

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
endif

function! Grep(...) abort
  return system(join(extend([&grepprg], a:000), ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<q-args>)
nnoremap <leader>G :Grep<space>
" }}}
" Make on save {{{
" Run &makeprg on filesave
let g:makeonsave = []
function! s:ToggleMakeOnSaveFT() abort
  if get(g:makeonsave, &ft, '') == &ft
    call remove(g:makeonsave, &ft)
    echom '[MakeOnSave] off'
  else
    call add(g:makeonsave, &ft)
    echom '[MakeOnSave] on'
  endif
endfunction

function! s:MakeOnSaveFT() abort
  if get(g:makeonsave, &ft, '') == &ft && &ft != ''
    normal! mm
    silent make
    normal! `m
  endif
endfunction

augroup MakeOnSave
  autocmd!
  autocmd BufWritePost * call <sid>MakeOnSaveFT()
augroup end
command! -nargs=0 ToggleMakeOnSaveFT call <sid>ToggleMakeOnSaveFT()
nnoremap yom :<c-u>call <sid>ToggleMakeOnSaveFT()<cr>
" }}}
" }}}
" Appearance {{{
set synmaxcol=200
set termguicolors
set t_Co=256

function! GitStatus() abort
  return get(g:, 'loaded_fugitive', 0) ? fugitive#head() == '' ? '' : fugitive#head() . ' |' : ''
endfunction

function! PasteForStatusline() abort
  return &paste == 1 ? '[PASTE]' : ""
endfunction

set laststatus=2
set statusline=\ %f\ %*\ %r\ %m%{PasteForStatusline()}%=\ %{GitStatus()}\ %{&ft}\ \|\ %l/%L\ :\ %c\ %*
" }}}
" Plugins {{{
call plug#begin(g:vimdir . '/plugged')
Plug 'cideM/yui'

" Fuzzy find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-commentary'               " Commenting
Plug 'tpope/vim-fugitive'                 " Git integration
Plug 'tpope/vim-unimpaired'               " Bindings
Plug 'tpope/vim-sleuth'                   " Wise indent style
Plug 'justinmk/vim-dirvish'               " Managing files (netrw is buggy)
Plug 'machakann/vim-sandwich'             " Surround objects
Plug 'mbbill/undotree'                    " Undo tree (undolist is too hard)
Plug 'godlygeek/tabular'                  " Align stuff
Plug 'ervandew/supertab'                  " Completion

" nvim-0.5
Plug 'neovim/nvim-lsp'
" Plug 'haorenW1025/completion-nvim'
Plug 'haorenW1025/diagnostic-nvim'
call plug#end()

packadd cfilter
" }}}
" Plugin configuration {{{
" nvim-lsp {{{
" augroup nvim-lsp
"   autocmd!
"   autocmd BufEnter * lua require'completion'.on_attach()
" augroup end

lua << EOF
  local nvim_lsp = require('nvim_lsp')

  local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require'diagnostic'.on_attach()
    -- require'completion'.on_attach()

    -- Mappings.
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gD'        , '<Cmd>lua vim.lsp.buf.declaration()<CR>'            , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gd'        , '<Cmd>lua vim.lsp.buf.definition()<CR>'             , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'K'         , '<Cmd>lua vim.lsp.buf.hover()<CR>'                  , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gi'        , '<cmd>lua vim.lsp.buf.implementation()<CR>'         , opts)
    -- vim.api.nvim_buf_set_keymap(bufnr    , 'n' , '<C-k>'     , '<cmd>lua vim.lsp.buf.signature_help()<CR>'         , opts)
    -- vim.api.nvim_buf_set_keymap(bufnr , 'n' , 'gy' , '<cmd>lua vim.lsp.buf.type_definition()<CR>'        , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gR'        , '<cmd>lua vim.lsp.buf.rename()<CR>'                 , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gr'        , '<cmd>lua vim.lsp.buf.references()<CR>'             , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , '<leader>f' , '<cmd>lua vim.lsp.buf.formatting()<CR>'             , opts)
    -- vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>e' , '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>' , opts)
  end

  local servers = {'bashls', 'tsserver', 'pyls'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

" <c-w>p to jump to floating window
let g:completion_chain_complete_list = {
      \ 'default': [
      \     {'complete_items': ['path'], 'triggered_only': ['/']},
      \     {'complete_items': ['lsp']},
      \     {'mode': '<c-p>'},
      \     {'mode': '<c-n>'}
      \ ],
      \ 'comment': []
      \ }

" function! s:check_back_space() abort
"   let col = col('.') - 1
"   return !col || getline('.')[col - 1]  =~ '\s'
" endfunction

" inoremap <silent><expr> <TAB>
"       \ pumvisible() ? "\<C-n>" :
"       \ <SID>check_back_space() ? "\<TAB>" :
"       \ completion#trigger_completion()

" inoremap <silent><expr> <S-TAB>
"       \ pumvisible() ? "\<C-p>" : "\<S-TAB>"

" imap  <c-j> <Plug>(completion_next_source)
" imap  <c-k> <Plug>(completion_prev_source)

" let g:completion_enable_snippet = 'UltiSnips'
let g:completion_enable_auto_paren = 1
" let g:completion_enable_auto_popup = 0
let g:completion_auto_change_source = 1
let g:completion_trigger_character = ['.', '::', '/']
let g:completion_enable_auto_hover = 0
let g:completion_enable_fuzzy_match = 1
let g:diagnostic_enable_virtual_text = 0
" let g:completion_trigger_keyword_length = 3

call sign_define("LspDiagnosticsErrorSign", {"text" : "!", "texthl" : "LspDiagnosticsError"})
call sign_define("LspDiagnosticsWarningSign", {"text" : "!", "texthl" : "LspDiagnosticsWarning"})
call sign_define("LspDiagnosticsInformationSign", {"text" : "-", "texthl" : "LspDiagnosticsInformation"})
call sign_define("LspDiagnosticsHintSign", {"text" : "-", "texthl" : "LspDiagnosticsHint"})
" }}}
" supertab {{{
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabContextDefaultCompletionType = ""
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextDiscoverDiscovery = ["&omnifunc:"]
" }}}
" fzf.vim {{{
function! Browse() abort
  if trim(system('git rev-parse --is-inside-work-tree')) ==# 'true'
    " Use this because Gfiles doesn't work with cached files
    call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))
  else
    exe "Files"
  endif
endfunction

nnoremap <silent><c-p> :call Browse()<CR>
nnoremap <silent><leader>b :Buffers<CR>
nnoremap <silent><leader>l :BLines<CR>
nnoremap <silent><leader>h :History<CR>

let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

" floating fzf window with borders
function! CreateCenteredFloatingWindow()
    let width = min([&columns - 4, max([80, &columns - 20])])
    let height = min([&lines - 4, max([20, &lines - 10])])
    let top = ((&lines - height) / 2) - 1
    let left = (&columns - width) / 2
    let opts = {'relative': 'editor', 'row': top, 'col': left, 'width': width, 'height': height, 'style': 'minimal'}

    let top = "╭" . repeat("─", width - 2) . "╮"
    let mid = "│" . repeat(" ", width - 2) . "│"
    let bot = "╰" . repeat("─", width - 2) . "╯"

    " let top = "+" . repeat("-", width - 2) . "+"
    " let mid = "|" . repeat(" ", width - 2) . "|"
    " let bot = "+" . repeat("-", width - 2) . "+"

    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'Normal', 'CursorColumn', 'String'],
      \ 'bg+':     ['bg', 'Normal', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Comment'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }
" }}}
" undotree {{{
let g:undotree_SplitWidth = 35
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>
" }}}
" dirvish {{{
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>

nnoremap <silent><c-n> :<C-u>call <sid>dirvish_toggle()<cr>
function! s:dirvish_toggle() abort
  let l:last_buffer = bufnr('$')
  let l:i = 1
  let l:dirvish_already_open = 0

  while l:i <= l:last_buffer
    if bufexists(l:i) && bufloaded(l:i) && getbufvar(l:i, '&filetype') ==? 'dirvish'
      let l:dirvish_already_open = 1
      execute ':'.l:i.'bd!'
    endif
    let l:i += 1
  endwhile

  if !l:dirvish_already_open
    leftabove vsplit | vertical resize 30 | Dirvish
  endif
endfunction
" }}}
" vim-fugitive {{{
nnoremap <silent><leader>g :vertical Gstatus<CR>
" }}}
" vim-sandwich {{{
runtime macros/sandwich/keymap/surround.vim
" }}}
" colorscheme {{{
set background=light
let g:yui_comments = 'emphasize'
let g:yui_folds = 'emphasize'
colorscheme yui
" }}}
" }}}
" Local settings {{{
let s:vimrc_local = fnamemodify(resolve(expand('<sfile>:p')), ':h').'/vimrc_local'
if filereadable(s:vimrc_local)
  execute 'source' s:vimrc_local
endif
" }}}
