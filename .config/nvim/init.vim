" Plugins {{{
let g:vim_dir = fnamemodify($MYVIMRC, ':p:h')
call plug#begin(g:vim_dir . '/plugged')

Plug 'MarcWeber/vim-addon-mw-utils'                     " Snippets dep
Plug 'tomtom/tlib_vim'                                  " Snippets dep
Plug 'garbas/vim-snipmate'                              " Snippets
" Plug 'honza/vim-snippets'                               " Actual snippets

Plug 'christoomey/vim-tmux-runner'                      " Run commands in tmux
Plug 'christoomey/vim-tmux-navigator'                   " Make vim better with tmux
Plug 'tmux-plugins/vim-tmux-focus-events'               " Fix tmux focus events

Plug 'NLKNguyen/papercolor-theme'                       " Colorscheme
Plug 'tpope/vim-commentary'                             " Commenting
Plug 'tpope/vim-fugitive'                               " Git integration
Plug 'tpope/vim-unimpaired'                             " Bindings
Plug 'tpope/vim-dispatch'                               " Async jobs
Plug 'wellle/targets.vim'                               " More text objects
Plug 'machakann/vim-sandwich'                           " Surround objects
Plug 'justinmk/vim-dirvish'                             " Direcotry browser. Netrw is buggy
Plug 'romainl/vim-qf'                                   " Better quickfix window
Plug 'editorconfig/editorconfig-vim'                    " Respect editorconfig
Plug 'ludovicchabant/vim-gutentags'                     " Tags
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                                 " Fyzzy find anything you want
Plug 'junegunn/vim-easy-align'                          " Align stuff
Plug 'Glench/Vim-Jinja2-Syntax'                         " Syntax files
Plug 'MaxMEllon/vim-jsx-pretty'

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

" Sorting
function! SortLines(type) abort
    '[,']sort i
endfunction
xnoremap <silent> gs :sort i<cr>
nnoremap <silent> gs :set opfunc=SortLines<cr>g@

nnoremap Y y$

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
xnoremap $t :t''<CR>
xnoremap $T :T''<CR>
xnoremap $m :m''<CR>
xnoremap $M :M''<CR>

" Disable exmode
nnoremap Q <nop>

" Saving
noremap  <silent><c-s> <Esc>:update<CR>
inoremap <silent><c-s> <Esc>:update<CR>a
xnoremap <silent><c-s> <Esc>:update<CR>gv

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

" Terminal mode esc
tnoremap <Esc> <C-\><C-n>

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

set pastetoggle=<F2>
" }}}
" Plugin configuration {{{
" snipmate {{{
command! -nargs=? -complete=filetype EditSnippets
            \ execute 'keepj vsplit ' . g:vim_dir . '/snippets/' .
            \ (empty(<q-args>) ? &ft : <q-args>) . '.snippets'
" }}}
" vim-tmux-runner {{{
let g:VtrPercentage = 35
let g:VtrOrientation = "h"
nnoremap gr :VtrSendCommandToRunner!<space>
xnoremap gr :VtrSendLinesToRunner!<CR>
" }}}
" vim-tmux-navigator {{{
tnoremap <silent> <c-h> <C-\><C-n>:TmuxNavigateLeft<cr>
tnoremap <silent> <c-j> <C-\><C-n>:TmuxNavigateDown<cr>
tnoremap <silent> <c-k> <C-\><C-n>:TmuxNavigateUp<cr>
tnoremap <silent> <c-l> <C-\><C-n>:TmuxNavigateRight<cr>
" }}}
" editorconfig {{{
let g:EditorConfig_exclude_patterns = ['fugitive://.*']
" }}}
" ultisnips {{{
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
" }}}
" vim-fugitive {{{
nnoremap <silent><leader>g :botright vertical Gstatus<CR>
" }}}
" fzf.vim {{{
function! InGit()
    let l:is_git_dir = trim(system('git rev-parse --is-inside-work-tree'))
    return l:is_git_dir ==# 'true'
endfunction

function! Browse()
    if InGit()
        " Use this because Gfiles doesnt work with cached files
        call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))
    else
        exe "Files"
    endif
endfunction

function! SimilarFZF()
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
endfunction

nnoremap <silent><leader>A :call SimilarFZF()<CR>
nnoremap <silent><leader>F :Files<CR>
nnoremap <silent><c-p> :call Browse()<CR>
nnoremap <silent><leader>b :Buffers<CR>
nnoremap <silent><leader>l :BLines<CR>
nnoremap <silent><leader>h :History<CR>

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
" vim-dispatch {{{
let g:dispatch_no_tmux_make = 1
" }}}
" vim-easy-align {{{
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)
" }}}
" vim-sandwich {{{
runtime macros/sandwich/keymap/surround.vim
" }}}
" vim-qf {{{
" https://github.com/romainl/vim-qf/issues/85
let g:qf_auto_open_quickfix = 0
autocmd MyAutocmds QuickFixCmdPost make,grep,grepadd,cgetexpr nested cwindow
autocmd MyAutocmds QuickFixCmdPost make,grep,grepadd,cgetexpr nested lwindow
nmap [q <Plug>(qf_qf_previous)
nmap ]q  <Plug>(qf_qf_next)

nmap [l <Plug>(qf_loc_previous)
nmap ]l  <Plug>(qf_loc_next)
" }}}
" }}}
" Basic {{{
let g:python3_host_prog = "/usr/bin/python3"

filetype plugin indent on
set hidden
set laststatus=2
set splitright
set mouse=a
set nowrap
set list listchars=tab:→\ ,nbsp:•,trail:•
set autoread
set showmatch
set ignorecase
set inccommand=split
set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*
set wildignore+=*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls
set wildignore+=*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk,*/build/*

set path+=**
set clipboard=unnamedplus
set lazyredraw

" Completion
set pumheight=10
" set shortmess+=c
set completeopt+=menuone,longest,noselect

" Indent
set autoindent
set cindent
set smartindent

" Search
set nohlsearch
set incsearch

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
set diffopt=vertical

set omnifunc=syntaxcomplete#Complete
autocmd MyAutocmds FocusLost,BufLeave * silent! update
" }}}
" Commands {{{
command! -nargs=0 ConfigVs execute ':vsplit' . $MYVIMRC
command! -nargs=0 Config execute ':edit' . $MYVIMRC
nnoremap <leader>c :ConfigVs<CR>

" Recursively create directories to the new file
command! -nargs=1 E execute('silent! !mkdir -p "$(dirname "<args>")"') <Bar> e <args>

" Open ftplugin {{{
command! -nargs=? -complete=filetype EditFileTypePlugin
            \ execute 'keepj vsplit ' . g:vim_dir . '/after/ftplugin/' .
            \ (empty(<q-args>) ? &ft : <q-args>) . '.vim'
" }}}
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
        if exists('g:loaded_dispatch')
            exe 'Make'|Copen|wincmd p
        else
            silent make
        endif
    endif
endfunction

autocmd MyAutocmds BufWritePost * call MakeOnSave()
command! -nargs=0 ToggleMakeOnSave call ToggleMakeOnSave()
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
" }}}
" Appearance {{{
set cursorline
let &colorcolumn=join(range(101,999), ",")
set termguicolors
set t_Co=256
colorscheme PaperColor
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
