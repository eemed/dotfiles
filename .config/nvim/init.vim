"    (_)___  (_) /__   __(_)___ ___
"   / / __ \/ / __/ | / / / __ `__ \
"  / / / / / / /__| |/ / / / / / / /
" /_/_/ /_/_/\__(_)___/_/_/ /_/ /_/
"
"

" Configurable {{{
let mapleader = "\ "
let config = "~/.config/nvim/init.vim"
let g:python3_host_prog = "/usr/bin/python3"
" }}}

" Autoinstall vim-plug {{{
if empty(glob('~/.config/nvim/autoload/plug.vim'))
    silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source '~/config/nvim/init.vim'
endif
" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')
Plug 'christoomey/vim-tmux-navigator'           " Make vim better with tmux
Plug 'tmux-plugins/vim-tmux-focus-events'

Plug 'morhetz/gruvbox'
Plug 'eemed/sitruuna.vim'                       " Colorscheme

Plug 'tpope/vim-commentary'                     " Commenting
Plug 'tpope/vim-fugitive'                       " Git integration
Plug 'tpope/vim-unimpaired'                     " Bindings
Plug 'tpope/vim-dispatch'                       " Async jobs

Plug 'wellle/targets.vim'                       " More text objects
Plug 'machakann/vim-sandwich'                   " Surround objects
Plug 'justinmk/vim-dirvish'
Plug 'romainl/vim-qf'

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                         " Fyzzy find anything you want
Plug 'junegunn/vim-easy-align'                  " Align stuff

Plug 'ludovicchabant/vim-gutentags'             " Tags
Plug 'norcalli/nvim-colorizer.lua'              " Colors

" Compiler to use with dispatch for erlang
Plug 'vim-erlang/vim-erlang-compiler'

" jinja 2 syntax. Used alot in ansible.
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'MaxMEllon/vim-jsx-pretty'
call plug#end()
" }}}

" Plugin configuration {{{
" neosnippet {{{
xmap <tab> <Plug>(neosnippet_expand_target)
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
            \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
let g:neosnippet#snippets_directory="~/.config/nvim/snips"
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
        return ''
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
            \ 'markers': {
            \ '.git': 'git ls-files',
            \ },
            \ }
" }}}

" vim-easy-align {{{
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)
" }}}

" vim-sandwich {{{
runtime macros/sandwich/keymap/surround.vim
" }}}

" dispatch {{{
nnoremap <leader>r :Start<CR>
" }}}

" vim-qf {{{
nmap <leader>t <Plug>(qf_qf_toggle)
nmap <leader>T <Plug>(qf_loc_toggle)

nmap [q <Plug>(qf_qf_previous)
nmap ]q  <Plug>(qf_qf_next)

nmap [l <Plug>(qf_loc_previous)
nmap ]l  <Plug>(qf_loc_next)
" }}}
" }}}

" Keybindings {{{
nnoremap Y y$

" Move text
xnoremap J :move '>+1<CR>gv=gv
xnoremap K :move '<-2<CR>gv=gv
xnoremap < <gv
xnoremap > >gv

nnoremap <leader>a ggVG
nnoremap <leader>q :q<CR>
nnoremap <BS> <C-^>

" Toggle layouts
nnoremap <leader>sf :silent exec "! setxkbmap fi"<CR>
nnoremap <leader>su :silent exec "! setxkbmap us"<CR>

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

" Strip whitspace
nnoremap <leader>S :%s/\s\+$//e<CR>

nnoremap <leader><right> :vertical resize +10<CR>
nnoremap <leader><left> :vertical resize -10<CR>
nnoremap <leader><up> :resize +10<CR>
nnoremap <leader><down> :resize -10<CR>

set pastetoggle=<F2>
" }}}

" Basic {{{
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
set shortmess+=c
set completeopt+=menuone,noselect,longest

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
" }}}

" Commands {{{
command! -nargs=0 ConfigVs execute ':vsplit' . config
command! -nargs=0 Config execute ':edit' . config
nnoremap <leader>c :ConfigVs<CR>

" Recursively create directories to the new file
command! -nargs=1 E execute('silent! !mkdir -p "$(dirname "<args>")"') <Bar> e <args>

" List highlight groups {{{
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
" }}}

" Navigate to the next fold {{{
function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
    let view = winsaveview()
    let [l0, l, open] = [0, view.lnum, 1]
    while l != l0 && open
        exe cmd
        let [l0, l] = [l, line('.')]
        let open = foldclosed(l) < 0
    endwhile
    if open
        call winrestview(view)
    endif
endfunction

nnoremap <silent> <leader>zj :call NextClosedFold('j')<cr>
nnoremap <silent> <leader>zk :call NextClosedFold('k')<cr>
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

augroup quickfix
    autocmd!
    autocmd QuickFixCmdPost cgetexpr cwindow
    autocmd QuickFixCmdPost lgetexpr lwindow
augroup END

nnoremap <leader>f :Grep<space>
" }}}

" Terminal {{{
nnoremap <silent> <M-t> :call TermToggle(12)<CR>
inoremap <silent> <M-t> <Esc>:call TermToggle(12)<CR>
xnoremap <silent> <M-t> <Esc>:call TermToggle(12)<CR>
tnoremap <silent> <M-t> <C-\><C-n>:call TermToggle(12)<CR>

" Terminal Function
let g:term_buf = 0
let g:term_win = 0
function! TermToggle(height)
    if win_gotoid(g:term_win)
        hide
    else
        botright new
        exec "resize " . a:height
        try
            exec "buffer " . g:term_buf
        catch
            call termopen($SHELL, {"detach": 0})
            let g:term_buf = bufnr("")
            set nonumber
            set norelativenumber
            set signcolumn=no
        endtry
        startinsert!
        let g:term_win = win_getid()
    endif
endfunction
" }}}
" }}}

" Appearance {{{
let g:gruvbox_invert_selection=0
colorscheme gruvbox
set cursorline
let &colorcolumn=join(range(101,999), ",")
set termguicolors
set t_Co=256

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
" }}}

" Autocommands {{{
augroup basic
    autocmd!
    autocmd FocusLost,BufLeave * silent! update
augroup end
" }}}

