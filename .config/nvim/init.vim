" Setup {{{
let g:vimdir = stdpath('config')
let g:python3_host_prog = '/usr/bin/python3'

" Install vim-plug
if empty(glob(g:vimdir . '/autoload/plug.vim'))
  execute 'silent !curl -fLo ' . g:vimdir . '/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

augroup MyAutocmds
  autocmd!
augroup end
" }}}
" Key mappings {{{
let mapleader = " "
let maplocalleader = "\\"

nnoremap k gk
nnoremap j gj

imap <c-f> <c-g>u<Esc>[s1z=`]a<c-g>u
nmap <c-f> mm[s1z=`m

nnoremap Y y$
tnoremap <esc> <c-\><c-n>

" Move text
xnoremap J :move '>+1<CR>gv=gv
xnoremap K :move '<-2<CR>gv=gv
xnoremap < <gv
xnoremap > >gv

nnoremap <leader>S :source <c-r>%<CR>
nnoremap <leader>q :q<CR>
nnoremap <BS> <C-^>

nnoremap Q @q
nnoremap gV `[v`]

" Saving
nnoremap <silent><c-s> :update<CR>
inoremap <silent><c-s> <c-o>:update<CR>

" Copy paste
nnoremap <leader>p "+p
nnoremap <leader>P "+P
nnoremap <leader>y "+y
xnoremap <leader>y "+y

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

nnoremap <M-right>  :vertical resize +10<CR>
nnoremap <M-left>   :vertical resize -10<CR>
nnoremap <M-up>     :resize +10<CR>
nnoremap <M-down>   :resize -10<CR>

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

nnoremap gF <c-w>f
set pastetoggle=<F2>
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

" Commands without remembering case. Useful for plugin commands
set ignorecase smartcase

" Show replacement
set inccommand=split
set wildignore+=*/node_modules/*,*/__pycache__/,*/venv/*,*.pyc,.git/*,*.pdf

" Completion
set pumheight=10
set completeopt+=noselect,menuone
set omnifunc=syntaxcomplete#Complete

set tags=./tags;,tags;

set smartindent
set nohlsearch

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

autocmd MyAutocmds FocusLost,BufLeave * silent! update
function! s:SetScrolloff() abort
  if index(['qf'], &filetype) == -1
    set scrolloff=5
    set sidescrolloff=10
  else
    set scrolloff=0
    set sidescrolloff=0
  endif
endfunction
autocmd MyAutocmds BufEnter,WinEnter * call <sid>SetScrolloff()

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
" Commands {{{
command! -nargs=0 Config execute ':edit ' . $MYVIMRC
nnoremap <leader>c :Config<CR>

command! -nargs=? -complete=filetype EditFileTypePlugin
      \ execute 'keepj vsplit ' . g:vimdir . '/after/ftplugin/' .
      \ (empty(<q-args>) ? &ft : <q-args>) . '.vim'
nnoremap <localleader>c :EditFileTypePlugin<cr>

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
nnoremap <leader>f :Grep<space>
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

autocmd MyAutocmds BufWritePost * call <sid>MakeOnSaveFT()
command! -nargs=0 ToggleMakeOnSaveFT call <sid>ToggleMakeOnSaveFT()
nnoremap yom :<c-u>call <sid>ToggleMakeOnSaveFT()<cr>
" }}}
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
inoremap <silent> <c-l> <c-o>:call <sid>FixKeys()<cr>
autocmd MyAutocmds InsertLeave * call <sid>RestoreKeys()
" }}}
" }}}
" Appearance {{{
set cursorline
set synmaxcol=200
set termguicolors
set t_Co=256

" Toggle cursor line on inactive window
autocmd MyAutocmds WinEnter * set cursorline
autocmd MyAutocmds WinLeave * set nocursorline

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
Plug 'arzg/vim-colors-xcode'              " Color scheme

Plug 'christoomey/vim-tmux-navigator'     " Move between tmux and vim splits
Plug 'tmux-plugins/vim-tmux-focus-events' " Fix tmux focus events

" Fuzzy find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'            " Align stuff

Plug 'tpope/vim-commentary'               " Commenting
Plug 'tpope/vim-fugitive'                 " Git integration
Plug 'tpope/vim-unimpaired'               " Bindings
Plug 'tpope/vim-sleuth'                   " Wise indent style
Plug 'tpope/vim-endwise'                  " End structures

Plug '9mm/vim-closer'                     " End brackets
Plug 'justinmk/vim-dirvish'               " Managing files (netrw is buggy)
Plug 'romainl/vim-qf'                     " Quickfix window overall improvements
Plug 'machakann/vim-sandwich'             " Surround objects
Plug 'mbbill/undotree'                    " Undo tree (undolist is too hard)

Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'garbas/vim-snipmate'                " Snippets
Plug 'duggiefresh/vim-easydir'            " Automatically create directories
Plug 'lifepillar/vim-mucomplete'          " Complete
Plug 'eemed/vim-chained'                  " Chain functions

" Language server protocol until neovim implements its own
Plug 'autozimu/LanguageClient-neovim', {
      \ 'branch': 'next',
      \ 'do': 'bash install.sh',
      \ }

" Syntax
Plug 'pearofducks/ansible-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'rust-lang/rust.vim'
call plug#end() " }}}
" Plugin configuration {{{
" vim-chained {{{
function! FormatFile() abort
  if get(b:, 'formatcmd', '') == ''
    return -1
  else
    let l:view = winsaveview()
    let l:cmd = '%! ' . b:formatcmd
    silent execute l:cmd
    if v:shell_error > 0
      silent undo
      redraw
      echom 'Format command "' . b:formatcmd . '" failed.'
    endif
    call winrestview(l:view)
    return 0
  endif
endfunction

let g:chained#chains = {}
let g:chained#chains.hover = ["LanguageClientHover", "TagsHover", "DefaultHover"]
let g:chained#chains.definition = ["LanguageClientDefinition", "TagsDefinition", "DefaultDefinition"]
let g:chained#chains.references = ["LanguageClientReferences", "GrepPath"]
let g:chained#chains.format = ["FormatFile", "LanguageClientFormat"]

nnoremap <silent> K         :<c-u>call chained#ExecuteChain('hover')<cr>
nnoremap <silent> gd        :<c-u>call chained#ExecuteChain('definition')<cr>
nnoremap <silent> gD        :<c-u>call chained#ExecuteChainSplit('definition')<cr>
nnoremap <silent> gr        :<c-u>call chained#ExecuteChain('references')<cr>
nnoremap <silent> <leader>F :<c-u>call chained#ExecuteChain('format')<cr>
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

let g:fzf_colors = {
      \ 'fg':      ['fg', 'Normal'],
      \ 'bg':      ['bg', 'Normal'],
      \ 'hl':      ['fg', 'Comment'],
      \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
      \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
      \ 'hl+':     ['fg', 'Statement'],
      \ 'info':    ['fg', 'PreProc'],
      \ 'border':  ['fg', 'Ignore'],
      \ 'prompt':  ['fg', 'Conditional'],
      \ 'pointer': ['fg', 'Exception'],
      \ 'marker':  ['fg', 'Keyword'],
      \ 'spinner': ['fg', 'Label'],
      \ 'header':  ['fg', 'Comment'] }

nnoremap <silent><c-p> :call Browse()<CR>
nnoremap <silent><leader>b :Buffers<CR>
nnoremap <silent><leader>l :BLines<CR>
nnoremap <silent><leader>h :History<CR>
nnoremap <silent><leader>t :Tags<CR>
" }}}
" snipmate {{{
snoremap <bs> <c-v>c
command! -nargs=? -complete=filetype EditSnippets
      \ execute 'keepj vsplit ' . g:vimdir . '/snippets/' .
      \ (empty(<q-args>) ? &ft : <q-args>) . '.snippets'
nnoremap <localleader>s :EditSnippets<cr>
smap <c-e> <Plug>snipMateNextOrTrigger
imap <c-b> <Plug>snipMateBack
" }}}
" undotree {{{
let g:undotree_SplitWidth = 35
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>
" }}}
" mucomplete {{{
if get(g:, 'loaded_mucomplete', 0) == 0
  let g:mucomplete#no_mappings = 1
  let g:mucomplete#no_popup_mappings = 0

  let g:mucomplete#completion_delay = 100
  let g:mucomplete#reopen_immediately = 0
  let g:mucomplete#empty_text = 1

  imap <tab> <plug>(MUcompleteFwd)
  imap <s-tab> <plug>(MUcompleteBwd)
  imap <expr> <c-j> pumvisible() ? "\<plug>(MUcompleteCycFwd)" : "\<c-j>"
  imap <expr> <c-k> pumvisible() ? "\<plug>(MUcompleteCycBwd)" : "\<c-k>"
  imap <expr> <c-e> (pumvisible()
        \ ? "\<c-y>\<plug>snipMateNextOrTrigger"
        \ : "\<plug>snipMateNextOrTrigger")
  nnoremap yoC :MUcompleteAutoToggle<cr>

  let g:snipMate = {}
  let g:snipMate['no_match_completion_feedkeys_chars'] = ''

  let g:mucomplete#chains = { 'default': ['snip', 'omni', 'path', 'c-n', 'uspl'] }
  set complete-=t
  set complete-=i
  set shortmess+=c    " Shut off completion messages

  let g:mucomplete#can_complete = {}
  let g:mucomplete#can_complete.default = { 'omni': { t -> t =~# '\m\k\k\%(\k\|\.\)$' } }
  let g:mucomplete#minimum_prefix_length = 3
  function! s:dismiss_or_delete()
    return pumvisible()
          \ && len(matchstr(getline('.'), '\S*\%'.col('.').'c')) <= get(g:, 'mucomplete#minimum_prefix_length', 4)
          \ ? "\<c-e>\<bs>" : "\<bs>"

  endfunction
  inoremap <expr> <bs> <sid>dismiss_or_delete()
endif
" }}}
" LanguageClient {{{
let g:LanguageClient_serverCommands = {
      \ 'rust': ['rustup', 'run', 'stable', 'rls'],
      \ 'javascript': ['npx', 'javascript-typescript-stdio'],
      \ }

function! s:LC_maps() abort
  if has_key(g:LanguageClient_serverCommands, &filetype)
    nnoremap <buffer> <f5>      :call LanguageClient_contextMenu()<CR>
  endif
endfunction

autocmd MyAutocmds FileType * call <sid>LC_maps()
let g:LanguageClient_useVirtualText      = "No"
let g:LanguageClient_diagnosticsSignsMax = 0
let g:LanguageClient_diagnosticsList     = "Location"
let g:LanguageClient_virtualTextPrefix   = '❯ '
" let g:LanguageClient_hasSnippetSupport   = 0
set signcolumn=no
" }}}
" vim-easyalign {{{
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)
" }}}
" vim-qf {{{
nmap [q <Plug>(qf_qf_previous)
nmap ]q <Plug>(qf_qf_next)

nmap [l <Plug>(qf_loc_previous)
nmap ]l <Plug>(qf_loc_next)
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
" vim-tmux-navigator {{{
let g:tmux_navigator_no_mappings = 1
nnoremap <silent> <m-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <m-j> :TmuxNavigateDown<cr>
nnoremap <silent> <m-k> :TmuxNavigateUp<cr>
nnoremap <silent> <m-l> :TmuxNavigateRight<cr>
tnoremap <silent> <m-h> <C-\><C-n>:TmuxNavigateLeft<cr>
tnoremap <silent> <m-j> <C-\><C-n>:TmuxNavigateDown<cr>
tnoremap <silent> <m-k> <C-\><C-n>:TmuxNavigateUp<cr>
tnoremap <silent> <m-l> <C-\><C-n>:TmuxNavigateRight<cr>
" }}}
" vim-fugitive {{{
nnoremap <silent><leader>g :vertical Gstatus<CR>
" }}}
" vim-sandwich {{{
runtime macros/sandwich/keymap/surround.vim
" }}}
" xcode {{{
let g:xcodedark_green_comments = 1
colorscheme xcodedark
" }}}
" }}}
" Local settings {{{
let s:vimrc_local = fnamemodify(resolve(expand('<sfile>:p')), ':h').'/vimrc_local'
if filereadable(s:vimrc_local)
  execute 'source' s:vimrc_local
endif
" }}}
