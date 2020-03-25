" Plugins {{{
let g:vim_dir = fnamemodify($MYVIMRC, ':p:h')
call plug#begin(g:vim_dir . '/plugged')

Plug 'MarcWeber/vim-addon-mw-utils'                     " Snippets dep
Plug 'tomtom/tlib_vim'                                  " Snippets dep
Plug 'garbas/vim-snipmate'                              " Snippets

Plug 'christoomey/vim-tmux-navigator'                   " Make vim better with tmux
Plug 'tmux-plugins/vim-tmux-focus-events'               " Fix tmux focus events

Plug 'tpope/vim-commentary'                             " Commenting
Plug 'tpope/vim-fugitive'                               " Git integration
Plug 'tpope/vim-unimpaired'                             " Bindings
Plug 'tpope/vim-sleuth'                                 " Wise style

Plug 'machakann/vim-sandwich'                           " Surround objects
Plug 'justinmk/vim-dirvish'                             " Direcotry browser. Netrw is buggy
Plug 'romainl/vim-qf'                                   " Better quickfix window
Plug 'ludovicchabant/vim-gutentags'                     " Tags
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                                 " Fyzzy find anything you want
Plug 'sheerun/vim-polyglot'                             " Syntax files
Plug 'eemed/vim-one'                                    " Colorscheme

call plug#end() " }}}
" Autoinstall vim-plug {{{
if empty(glob(g:vim_dir . '/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source '~/config/nvim/init.vim'
endif
" }}}
augroup MyAutocmds " {{{
    autocmd!
augroup end " }}}
" Keybindings {{{
let mapleader = "\ "

function! SortLines(type) abort
    '[,']sort i
endfunction
xnoremap <silent> gs :sort i<cr>
nnoremap <silent> gs :set opfunc=SortLines<cr>g@

nnoremap <expr> k v:count == 0 ? 'gk' : 'k'
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'

nnoremap Y y$
tnoremap <esc> <c-\><c-n>

" snipmate would switch to normal mode if <bs> was pressed and wouldn't work
" after re-entering insert mode
snoremap <bs> <c-v>xa

" Move text
xnoremap J :move '>+1<CR>gv=gv
xnoremap K :move '<-2<CR>gv=gv
xnoremap < <gv
xnoremap > >gv

nnoremap <leader>S :source %<CR>
nnoremap <leader>q :q<CR>
nnoremap <BS> <C-^>

" Copy or move text. Start at where you want to copy the text to
" find the block you want to copy using ? or / select it and use these bindings
" t = copy, m = move
xnoremap gt :t''<CR>
xnoremap gT :T''<CR>
xnoremap gm :m''<CR>
xnoremap gM :M''<CR>

" Disable exmode
nnoremap Q <nop>

" Saving
noremap  <silent><c-s> <Esc>:update<CR>
inoremap <silent><c-s> <Esc>:update<CR>a
xnoremap <silent><c-s> <Esc>:update<CR>gv

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

function! StripWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction
nnoremap <leader>s :call StripWhitespace()<cr>

nnoremap <c-right>  :vertical resize +10<CR>
nnoremap <c-left>   :vertical resize -10<CR>
nnoremap <c-up>     :resize +10<CR>
nnoremap <c-down>   :resize -10<CR>

xnoremap ir i[
onoremap ir :normal vi[<CR>
xnoremap ar a[
onoremap ar :normal va[<CR>

nnoremap m<cr> :make<CR>
nnoremap m? :echom &makeprg<CR>
nnoremap m<space> :set makeprg=

set pastetoggle=<F2>
" }}}
" Plugin configuration {{{
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
    leftabove 30vsp +Dirvish
  endif
endfunction
autocmd MyAutocmds bufenter * if (winnr("$") == 1 && exists("b:dirvish")) | q | endif
" }}}
" snipmate {{{
command! -nargs=? -complete=filetype EditSnippets
            \ execute 'keepj vsplit ' . g:vim_dir . '/snippets/' .
            \ (empty(<q-args>) ? &ft : <q-args>) . '.snippets'
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
nnoremap <silent><leader>g :botright vertical Gstatus<CR>
" }}}
" fzf.vim {{{
function! InGit() " {{{
    let l:is_git_dir = trim(system('git rev-parse --is-inside-work-tree'))
    return l:is_git_dir ==# 'true'
endfunction " }}}
function! Browse() " {{{
    if InGit()
        " Use this because Gfiles doesnt work with cached files
        call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))
    else
        exe "Files"
    endif
endfunction " }}}
function! SimilarFZF() " {{{
    try
        let l:filename = split(tolower(expand('%:t:r')), '\v\A|(test)')[0]
        let l:files = globpath('.', '**/' . l:filename .'*')
    catch /.*/
        echom 'Failed to get files.'
        return
    endtry
    if l:files != ''
        call fzf#run(fzf#wrap({'source':
                    \  split(globpath('.', '**/' . l:filename .'*')),
                    \ 'down' : '20%'}))
    else
        echom 'No similar files'
    endif
endfunction " }}}
" Fzf colors {{{
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
" }}}
nnoremap <silent><leader>A :call SimilarFZF()<CR>
nnoremap <silent><c-p> :call Browse()<CR>
nnoremap <silent><leader>b :Buffers<CR>
nnoremap <silent><leader>l :BLines<CR>
nnoremap <silent><leader>h :History<CR>
" }}}
" vim-gutentags {{{
let g:gutentags_cache_dir    = '~/.tags'
let g:gutentags_project_root = ['.gitignore']
let g:gutentags_project_info = [
            \ {'type': 'haskell', 'glob': '*.hs'}
            \ ]
let g:gutentags_ctags_executable_haskell = 'hasktags-gutentags-shim.sh'
let g:gutentags_file_list_command = {
            \   'markers': {
            \       '.git': 'git ls-files',
            \   },
            \ }
" }}}
" vim-sandwich {{{
runtime macros/sandwich/keymap/surround.vim
" }}}
" vim-qf {{{
" https://github.com/romainl/vim-qf/issues/85
let g:qf_auto_open_quickfix = 0
autocmd MyAutocmds QuickFixCmdPost make,grep,grepadd,cgetexpr nested cwindow
autocmd MyAutocmds QuickFixCmdPost lmake,lgrep,lgrepadd,lgetexpr nested lwindow

nmap [q <Plug>(qf_qf_previous)
nmap ]q  <Plug>(qf_qf_next)

nmap [l <Plug>(qf_loc_previous)
nmap ]l  <Plug>(qf_loc_next)
" }}}
" }}}
" Basic {{{
" let g:python3_host_prog = "/usr/bin/python3"

filetype plugin indent on
set hidden

" Splitting
set splitright
set splitbelow
set diffopt=vertical

set lazyredraw
set mouse=a
set nowrap
set list listchars=tab:→\ ,nbsp:•,trail:•
set breakindent
set showbreak=⤷
set path+=**
" set clipboard+=unnamedplus

" Commands without remembering case. Useful for plugin commands
set ignorecase
set smartcase

" Show replacement
set inccommand=split
set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*
set wildignore+=*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls
set wildignore+=*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*/build/*

" Completion
set pumheight=10
set completeopt=menu,longest
set omnifunc=syntaxcomplete#Complete

" Indent
set smartindent

" Search
set nohlsearch

" Tabs to spaces
set tabstop=4
set shiftwidth=4
set expandtab

" Use undo files
set undofile
set undodir=~/.vimtmp
set nobackup
set nowritebackup
set noswapfile
set dir=~/.vimtmp

set updatetime=300
set foldmethod=marker

autocmd MyAutocmds FocusLost,BufLeave * silent! update
autocmd MyAutocmds BufEnter term://* startinsert
autocmd MyAutocmds BufLeave term://* stopinsert
function! SetScrolloff() " {{{
    if index(['qf'], &filetype) == -1
        set scrolloff=5
        set sidescrolloff=10
    else
        set scrolloff=0
        set sidescrolloff=0
    endif
endfunction
autocmd MyAutocmds BufEnter,WinEnter * call SetScrolloff()
" }}}
" }}}
" Commands {{{
command! -nargs=0 Config execute ':edit' . $MYVIMRC
nnoremap <leader>c :Config<CR>
" Make on save {{{
let g:makeonsave = []
function! ToggleMakeOnSave()
    if get(g:makeonsave, &ft, '') == &ft
        call remove(g:makeonsave, &ft)
        echom 'MakeOnSave disabled'
    else
        call add(g:makeonsave, &ft)
        echom 'MakeOnSave enabled'
    endif
endfunction

function! MakeOnSave()
    if get(g:makeonsave, &ft, '') == &ft
        silent make
    endif
endfunction

autocmd MyAutocmds BufWritePost * call MakeOnSave()
command! -nargs=0 ToggleMakeOnSave call ToggleMakeOnSave()
" }}}
" Open ftplugin {{{
command! -nargs=? -complete=filetype EditFileTypePlugin
            \ execute 'keepj vsplit ' . g:vim_dir . '/after/ftplugin/' .
            \ (empty(<q-args>) ? &ft : <q-args>) . '.vim'
" }}}
" Grepping {{{
" https://gist.github.com/romainl/56f0c28ef953ffc157f36cc495947ab3
if executable('ag')
    set grepprg=ag\ --vimgrep\ --smart-case
endif

if executable('rg')
    set grepprg=rg\ --vimgrep\ --smart-case
endif

function! Grep(...)
    return system(join(extend([&grepprg], a:000), ' '))
endfunction

command! -nargs=+ -complete=file_in_path -bar Grep  cgetexpr Grep(<q-args>)
command! -nargs=+ -complete=file_in_path -bar LGrep lgetexpr Grep(<q-args>)

nnoremap <leader>f :Grep<space>
" }}}
" Hex representation {{{
function! AsHex()
    let l:name = expand('%:p')
    new
    setlocal buftype=nofile bufhidden=hide noswapfile filetype=xxd
    execute 'read !xxd ' .  shellescape(l:name, 1)
endfunction
command! -nargs=0 AsHex call AsHex()
" }}}
" }}}
" Appearance {{{
set cursorline
let &colorcolumn=join(range(101,999), ",")
set synmaxcol=200
set termguicolors
set t_Co=256
colorscheme one
" }}}
" Statusline {{{
function! GitStatus()
    return exists('#fugitive') ? fugitive#head() == '' ? '' : fugitive#head() . ' |' : ''
endfunction

function! PasteForStatusline()
    return &paste == 1 ? '[PASTE]' : ""
endfunction

set laststatus=2
set statusline=
set statusline+=\ %f
set statusline+=\ %*
set statusline+=\ %r
set statusline+=%m
set statusline+=%{PasteForStatusline()}
set statusline+=\ %{gutentags#statusline()}
set statusline+=%=
set statusline+=\ %{GitStatus()}
set statusline+=\ %{&ft}\ \|
set statusline+=\ %l/%L\ :\ %c
set statusline+=\ %*
" }}}
