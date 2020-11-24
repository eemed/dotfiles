" Section: Setup {{{

let g:vimdir = stdpath('config')
let g:python3_host_prog = '/usr/bin/python3'

augroup vimrc
  autocmd!
augroup end

" Install vim-plug
if empty(glob(g:vimdir . '/autoload/plug.vim'))
  execute 'silent !curl -fLo ' . g:vimdir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}
" Section: Key mappings {{{

let mapleader = " "

nnoremap k gk
nnoremap j gj

nnoremap <A-h> <c-w>h
nnoremap <A-j> <c-w>j
nnoremap <A-k> <c-w>k
nnoremap <A-l> <c-w>l

tnoremap <A-h> <c-\><c-n><c-w>h
tnoremap <A-j> <c-\><c-n><c-w>j
tnoremap <A-k> <c-\><c-n><c-w>k
tnoremap <A-l> <c-\><c-n><c-w>l

autocmd vimrc BufEnter,BufWinEnter,WinEnter term://* setlocal scrolloff=0 | startinsert!
autocmd vimrc BufLeave term://* stopinsert!

imap <silent><c-f> <c-g>u<Esc>[s1z=`]a<c-g>u
nmap <silent><c-f> mm[s1z=`m

nnoremap Y y$

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

inoremap <expr> / pumvisible() ? "\<c-y>\<c-x>\<c-f>" : "/"

nnoremap m<cr> :make<cr>
nnoremap m? :set makeprg<cr>

nnoremap <silent> [m m`:call search(&define, 'bW')<cr>
nnoremap <silent> ]m m`:call search(&define, "W")<CR>

set pastetoggle=<F2>

nnoremap <silent> [<space> :set paste<cr>m`O<esc>``:set nopaste<cr>
nnoremap <silent> ]<space> :set paste<cr>m`o<esc>``:set nopaste<cr>

nnoremap <silent> [t :tabNext<cr>
nnoremap <silent> ]t :tabprevious<cr>

" From unimpaired
function! s:JumpToConflictMarker(reverse) abort
  call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

nnoremap <silent> [n :<c-u>call <sid>JumpToConflictMarker(1)<cr>
nnoremap <silent> ]n :<c-u>call <sid>JumpToConflictMarker(0)<cr>

nnoremap yow :set wrap!<cr>:set wrap?<cr>
nnoremap yos :set spell!<cr>:set spell?<cr>
nnoremap yod :diffthis<cr>
nnoremap yon :set number!<cr>
nnoremap yor :set relativenumber!<cr>
nnoremap yom :<c-u>call ToggleMakeOnSaveFT()<cr>

function! s:ToggleBG()
    if &background == 'light'
        set background=dark
    else
        set background=light
    endif
endfunction
nnoremap <silent> yob :call <sid>ToggleBG()<cr>
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-r>=CustomCR()\<cr>"

tnoremap <esc> <c-\><c-n>

xnoremap <expr> I (mode() =~# '[vV]' ? '<c-v>^o^I' : 'I')
xnoremap <expr> A (mode() =~# '[vV]' ? '<c-v>0o$A' : 'A')

nnoremap gj i<c-j><esc>k$

" I need some finnish letters occasionally
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
autocmd vimrc InsertLeave * call <sid>RestoreKeys()
" }}}
" Section: Settings {{{

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
set path=.
set include=
set keywordprg=
set nrformats+=alpha

set clipboard=unnamed,unnamedplus

set pumheight=10
set completeopt=menu,menuone,noselect

" Commands without remembering case. Useful for plugin commands
set ignorecase smartcase

" Show replacement
set inccommand=split
set wildignore+=*/node_modules/*,*/__pycache__/,*/venv/*,*.pyc,.git/*,*.pdf

set smartindent
set hlsearch
nnoremap <silent><esc> :let @/ = ""<cr><esc>

" Use undo files
set undofile
set nobackup
set nowritebackup
set noswapfile
let &undodir = g:vimdir . '/undo'
let &dir = g:vimdir . '/swap'

set updatetime=300
set foldmethod=marker

set scrolloff=5

set shiftwidth=4
set softtabstop=-1
set expandtab

function s:MakeDirsToFile(dir)
  if a:dir =~ '^[a-z]\+:/'
    return
  endif

  if !isdirectory(a:dir)
    call mkdir(a:dir, 'p')
  endif
endfunction

" Autocreate dirs
autocmd vimrc BufWritePre,FileWritePre * call s:MakeDirsToFile(expand('<afile>:p:h'))

" Autosave
autocmd vimrc FocusLost,BufLeave * silent! update

autocmd vimrc BufLeave,InsertEnter * set nocursorline
autocmd vimrc BufEnter,InsertLeave * set cursorline
" }}}
" Section: Commands {{{
" Syn stack {{{
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" nmap <leader>sp :call <SID>SynStack()<CR>
" }}}
" Config, notes and filetypeplugin {{{
command! -nargs=0 Config execute ':edit ' . $MYVIMRC
nnoremap <leader>c :Config<CR>

" Notes uses autocreate directories
let g:note_dir = '~/.vim_notes'
command! -nargs=0 Notes execute ':edit ' . g:note_dir . '/index.md'

command! -nargs=? -complete=filetype EditFileTypePlugin
      \ execute 'keepj vsplit ' . g:vimdir . '/after/ftplugin/' .
      \ (empty(<q-args>) ? &ft : <q-args>) . '.vim'
" }}}
" Grep {{{
let &grepprg='grep -Rin --exclude=' . shellescape(&wildignore)

" https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
if executable('ag')
  set grepprg=ag\ --vimgrep\ --smart-case
endif

if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat^=%f:%l:%c:%m
endif

function! Grep(...) abort
  return system(join(extend([&grepprg], a:000), ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<q-args>)
cnoreabbrev <expr> grep  (getcmdtype() ==# ':' && getcmdline() ==# 'grep')  ? 'Grep'  : 'grep'
nnoremap <leader>G :Grep<space>
" }}}
" Open urls {{{
function! HandleURL()
    let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;()]*')
    if match(s:uri, 'http') != 0
      return
    endif
    let s:uri = shellescape(s:uri, 1)
    echom s:uri
    if s:uri != ""
        silent exec "!gio open '".s:uri."'"
        redraw!
    else
        echo "No URI found in line."
    endif
endfunction
nnoremap <silent> gx :call HandleURL()<CR>
" }}}
" }}}
" Section: Templates {{{
function! s:load_skeleton()
  filetype detect
  if empty(&filetype)
    return
  endif

  let skeleton_path = g:vimdir . '/templates/' . &filetype
  if filereadable(skeleton_path)
    execute '0read ' . skeleton_path
    $d
  endif
endfunction
autocmd vimrc BufNewFile * call s:load_skeleton()
" }}}
" Section: Appearance {{{

set synmaxcol=200
set termguicolors
set t_Co=256

function! PasteForStatusline() abort
  return &paste == 1 ? '[PASTE]' : ""
endfunction

set laststatus=2
set statusline=\ %f\ %*\ %r\ %m%{PasteForStatusline()}%=\ %{&ft}\ \|\ %l/%L\ :\ %c\ %<%*
" }}}
" Section: Plugins {{{
call plug#begin(g:vimdir . '/plugged')
Plug 'eemed/oldschool.vim'
Plug 'AlessandroYorba/Alduin', { 'branch': 'nightly' }

" Fuzzy find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Plug 'christoomey/vim-tmux-navigator'     " Tmux navigation
Plug 'tpope/vim-commentary'               " Commenting
Plug 'tpope/vim-fugitive'                 " Git integration
Plug 'tpope/vim-rsi'
Plug 'justinmk/vim-dirvish'               " Managing files (netrw is buggy)
Plug 'machakann/vim-sandwich'             " Surround objects
Plug 'mbbill/undotree'                    " Undo tree (undolist is too hard)
Plug 'godlygeek/tabular'                  " Align stuff
Plug 'ervandew/supertab'                  " Completion
Plug 'romainl/vim-qf'                     " Better quickfix

" nvim-0.5
if has('nvim-0.5')
  Plug 'neovim/nvim-lspconfig'
endif

" Syntax
Plug 'pearofducks/ansible-vim'
Plug 'MaxMEllon/vim-jsx-pretty'
call plug#end()
" }}}
" Section: Plugin configuration {{{
" Plugin: nvim-lsp {{{
if has('nvim-0.5')
  lua require('lsp')

  call sign_define("LspDiagnosticsErrorSign", {"text" : "!" })
  call sign_define("LspDiagnosticsWarningSign", {"text" : "!" })
  call sign_define("LspDiagnosticsInformationSign", {"text" : "-" })
  call sign_define("LspDiagnosticsHintSign", {"text" : "-" })
endif
" }}}
" Plugin: supertab {{{
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextDiscoverDiscovery = ["&omnifunc:<c-x><c-o>"]
" }}}
" Plugin: vim-qf {{{
nnoremap <silent> [L :lfirst<cr>
nnoremap <silent> [l :lprev<cr>
nnoremap <silent> ]l :lnext<cr>
nnoremap <silent> ]L :llast<cr>

nnoremap <silent> [Q :cfirst<cr>
nnoremap <silent> [q :cprev<cr>
nnoremap <silent> ]q :cnext<cr>
nnoremap <silent> ]Q :clast<cr>

nmap yol <plug>(qf_loc_toggle)
nmap yoq <plug>(qf_qf_toggle)
" }}}
" Plugin: fzf.vim {{{
function! Browse() abort
  if trim(system('git rev-parse --is-inside-work-tree')) ==# 'true'
    call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))
  else
    exe "Files"
  endif
endfunction

nnoremap <silent><c-p> :call Browse()<CR>
nnoremap <silent><leader>b :Buffers<CR>
nnoremap <silent><leader>l :BLines<CR>
nnoremap <silent><leader>h :History<CR>

let $FZF_DEFAULT_OPTS="--bind 'tab:down' --bind 'btab:up' --exact --reverse"
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

    let lines = [top] + repeat([mid], height - 2) + [bot]
    let s:buf = nvim_create_buf(v:false, v:true)
    call nvim_buf_set_lines(s:buf, 0, -1, v:true, lines)
    call nvim_open_win(s:buf, v:true, opts)
    set winhl=Normal:Normal
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction
" }}}
" Plugin: undotree {{{
let g:undotree_SplitWidth = 35
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>
" }}}
" Plugin: dirvish {{{
let g:loaded_netrwPlugin = 1
command! -nargs=? -complete=dir Explore Dirvish <args>
command! -nargs=? -complete=dir Sexplore belowright split | silent Dirvish <args>
command! -nargs=? -complete=dir Vexplore leftabove vsplit | silent Dirvish <args>
" }}}
" Plugin: vim-fugitive {{{
nnoremap <silent><leader>g :vertical Gstatus<CR>
" }}}
" Plugin: vim-sandwich {{{
runtime macros/sandwich/keymap/surround.vim
" }}}
" }}}
" Colorscheme {{{
set background=light

function! OldSchool()
    let g:fzf_colors = {
                \ 'fg':      ['fg', 'Normal'],
                \ 'bg':      ['bg', 'Normal'],
                \ 'hl':      ['fg', 'Special'],
                \ 'fg+':     ['fg', 'Normal'],
                \ 'bg+':     ['bg', 'Normal'],
                \ 'hl+':     ['fg', 'Special'],
                \ 'info':    ['fg', 'PreProc'],
                \ 'border':  ['fg', 'Ignore'],
                \ 'prompt':  ['fg', 'Conditional'],
                \ 'pointer': ['fg', 'Exception'],
                \ 'marker':  ['fg', 'Keyword'],
                \ 'spinner': ['fg', 'Label'],
                \ 'header':  ['fg', 'Comment']
                \ }
endfunction
autocmd vimrc ColorScheme oldschool call OldSchool()

function! Alduin()
    let g:fzf_colors = {
                \ 'fg':      ['fg', 'Normal'],
                \ 'bg':      ['bg', 'Normal'],
                \ 'hl':      ['fg', 'Special'],
                \ 'fg+':     ['fg', 'Normal'],
                \ 'bg+':     ['bg', 'Normal'],
                \ 'hl+':     ['fg', 'Special'],
                \ 'info':    ['fg', 'PreProc'],
                \ 'border':  ['fg', 'Ignore'],
                \ 'prompt':  ['fg', 'Conditional'],
                \ 'pointer': ['fg', 'Exception'],
                \ 'marker':  ['fg', 'Keyword'],
                \ 'spinner': ['fg', 'Label'],
                \ 'header':  ['fg', 'Comment']
                \ }

    highlight! link SignColumn LineNr
endfunction
autocmd vimrc ColorScheme alduin call Alduin()

colorscheme alduin
" }}}
" Section: Local settings {{{
execute 'silent! source' . g:vimdir . '/init.vim.local'
" }}}
