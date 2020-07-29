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

onoremap k gk
nnoremap j gj

" Window navigation
nnoremap <silent><c-h> :wincmd h<cr>
nnoremap <silent><c-j> :wincmd j<cr>
nnoremap <silent><c-k> :wincmd k<cr>
nnoremap <silent><c-l> :wincmd l<cr>

tnoremap <silent><c-h> <c-\><c-n>:wincmd h<cr>
tnoremap <silent><c-j> <c-\><c-n>:wincmd j<cr>
tnoremap <silent><c-k> <c-\><c-n>:wincmd k<cr>
tnoremap <silent><c-l> <c-\><c-n>:wincmd l<cr>

imap <silent><c-f> <c-g>u<Esc>[s1z=`]a<c-g>u
nmap <silent><c-f> mm[s1z=`m

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

inoremap <expr> / pumvisible() ? "\<c-y>\<c-x>\<c-f>" : "/"

nnoremap m<cr> :make<cr>
nnoremap m? :set makeprg<cr>

nnoremap <silent> [m m':call search(&define, 'bW')<cr>
nnoremap <silent> ]m m':call search(&define, "W")<CR>

set pastetoggle=<F2>

nnoremap [<space> mmO<esc>`m
nnoremap ]<space> mmo<esc>`m

nnoremap [t :tabNext<cr>
nnoremap ]t :tabprevious<cr>

" From unimpaired
function! JumpToConflictMarker(reverse) abort
  call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

nnoremap [n :<c-u>call <sid>JumpToConflictMarker(1)<cr>
nnoremap ]n :<c-u>call <sid>JumpToConflictMarker(0)<cr>

nnoremap yow :set wrap!<cr>
nnoremap yos :set spell!<cr>
nnoremap yod :diffthis<cr>
nnoremap yon :set number!<cr>
nnoremap yom :<c-u>call ToggleMakeOnSaveFT()<cr>

function! ToggleBG()
    if &background == 'light'
        set background=dark
    else
        set background=light
    endif
endfunction
nnoremap yob :call ToggleBG()<cr>
inoremap <expr> <cr> pumvisible() ? "\<c-y>" : "\<c-r>=CustomCR()\<cr>"

" Terminal
tnoremap <esc> <c-\><c-n>
tnoremap <c-v> <c-\><c-n>pi

nnoremap `<space> :Tmux<space>
nnoremap `<cr> :Tmux<cr>
nnoremap `! :Tmux!<space>
nnoremap `? :TmuxStatus<cr>
nmap gx <Plug>TmuxMotionSend
xmap gx <Plug>TmuxVisualSend
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

set pumheight=10
set completeopt=menu,menuone

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

" Sane path with git {{{
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
  " Autocreate dirs
  autocmd BufWritePre,FileWritePre * silent! call mkdir(expand('<afile>:p:h'), 'p')

  " Automatically insert mode in terminal
  " autocmd BufWinEnter,WinEnter term://* setlocal scrolloff=0 | startinsert
  " autocmd BufLeave term://* stopinsert

  " Autosave
  autocmd FocusLost,BufLeave * silent! update

  autocmd! BufLeave,InsertEnter * set nocursorline
  autocmd! BufEnter,InsertLeave * set cursorline
augroup end " }}}
" }}}
" Commands {{{
command! -nargs=0 Config execute ':edit ' . $MYVIMRC
nnoremap <leader>c :Config<CR>

" Notes uses autocreate directories
let g:note_dir = '~/.vim_notes'
command! -nargs=0 Notes execute ':edit ' . g:note_dir . '/index.md'

command! -nargs=? -complete=filetype EditFileTypePlugin
      \ execute 'keepj vsplit ' . g:vimdir . '/after/ftplugin/' .
      \ (empty(<q-args>) ? &ft : <q-args>) . '.vim'

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
" }}}
" Appearance {{{
set synmaxcol=200
set termguicolors
set t_Co=256

function! PasteForStatusline() abort
  return &paste == 1 ? '[PASTE]' : ""
endfunction

set laststatus=2
set statusline=\ %f\ %*\ %r\ %m%{PasteForStatusline()}%=\ %{&ft}\ \|\ %l/%L\ :\ %c\ %<%*
" }}}
" Plugins {{{
call plug#begin(g:vimdir . '/plugged')
Plug 'NLKNguyen/papercolor-theme'

" Fuzzy find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'christoomey/vim-tmux-navigator'     " Tmux navigation
Plug 'tpope/vim-commentary'               " Commenting
Plug 'tpope/vim-fugitive'                 " Git integration
Plug 'justinmk/vim-dirvish'               " Managing files (netrw is buggy)
Plug 'machakann/vim-sandwich'             " Surround objects
Plug 'mbbill/undotree'                    " Undo tree (undolist is too hard)
Plug 'godlygeek/tabular'                  " Align stuff
Plug 'ervandew/supertab'                  " Completion
Plug 'romainl/vim-qf'                     " Better quickfix

" nvim-0.5
if has('nvim-0.5')
  Plug 'neovim/nvim-lsp'
endif

" Syntax
Plug 'pearofducks/ansible-vim'
call plug#end()
" }}}
" Plugin configuration {{{
" nvim-lsp {{{
if has('nvim-0.5')
  lua require('lsp')
  call sign_define("LspDiagnosticsErrorSign", {"text" : "!" })
  call sign_define("LspDiagnosticsWarningSign", {"text" : "!" })
  call sign_define("LspDiagnosticsInformationSign", {"text" : "-" })
  call sign_define("LspDiagnosticsHintSign", {"text" : "-" })
endif
" }}}
" supertab {{{
let g:SuperTabDefaultCompletionType = "context"
let g:SuperTabCompletionContexts = ['s:ContextText', 's:ContextDiscover']
let g:SuperTabContextDiscoverDiscovery = ["&omnifunc:<c-x><c-o>"]
" }}}
" vim-qf {{{
nmap ]q <plug>(qf_qf_next)
nmap [q <plug>(qf_qf_previous)

nmap ]l <plug>(qf_loc_next)
nmap [l <plug>(qf_loc_previous)

nmap yol <plug>(qf_loc_toggle)
nmap yoq <plug>(qf_qf_toggle)
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

let $FZF_DEFAULT_OPTS='--layout=reverse --exact'
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
    set winhl=Normal:Floating
    let opts.row += 1
    let opts.height -= 2
    let opts.col += 2
    let opts.width -= 4
    call nvim_open_win(nvim_create_buf(v:false, v:true), v:true, opts)
    au BufWipeout <buffer> exe 'bw '.s:buf
endfunction

let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
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

function! Nvim5HL() abort
  " Add nvim 0.5 highlighting
  highlight! link LspDiagnosticsErrorSign Error
  highlight! link LspDiagnosticsWarningSign WarningMsg
  highlight! link LspDiagnosticsInformationSign Function
  highlight! link LspDiagnosticsHintSign Function
endfunction!

augroup Colors
  autocmd!
  autocmd ColorScheme * call Nvim5HL()
augroup end
colorscheme PaperColor
" }}}
" }}}
" Local settings {{{
let s:vimrc_local = fnamemodify(resolve(expand('<sfile>:p')), ':h').'/init.vim.local'
if filereadable(s:vimrc_local)
  execute 'source' s:vimrc_local
endif
" }}}
