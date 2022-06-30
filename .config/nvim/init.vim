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

nnoremap § <esc>
inoremap § <esc>
xnoremap § <esc>
cnoremap § <c-u><bs>

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

inoremap <silent><A-f> <c-g>u<Esc>[s1z=`]a<c-g>u
nnoremap <silent>[F mm[s1z=`m
nnoremap <silent>]F mm]s1z=`m

nnoremap Y y$

nnoremap ` V
xnoremap < <gv
xnoremap > >gv
xnoremap K :<c-u>execute "normal gvd" . v:count1 . "kPV']"<cr>
xnoremap J :<c-u>execute "normal gvd" . v:count1 . "jPV']"<cr>

nnoremap c# #``cgN
nnoremap c* *``cgn

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
inoremap <A-BS> <c-o>diw

nnoremap m<cr> :make<cr>
nnoremap m? :set makeprg<cr>

nnoremap <silent> [m m`:call search(&define, 'bW')<cr>
nnoremap <silent> ]m m`:call search(&define, "W")<CR>

set pastetoggle=<F2>

nnoremap <silent> [<space> :set paste<cr>m`O<esc>``:set nopaste<cr>
nnoremap <silent> ]<space> :set paste<cr>m`o<esc>``:set nopaste<cr>

xnoremap <silent> [<space> <esc>`<O<esc>gv
xnoremap <silent> ]<space> <esc>`>o<esc>gv

nnoremap <silent> [t :tabnext<cr>
nnoremap <silent> ]t :tabprevious<cr>

" From unimpaired
function! s:JumpToConflictMarker(reverse) abort
    call search('^\(@@ .* @@\|[<=>|]\{7}[<=>|]\@!\)', a:reverse ? 'bW' : 'W')
endfunction

nnoremap <silent> [n :<c-u>call <sid>JumpToConflictMarker(1)<cr>
nnoremap <silent> ]n :<c-u>call <sid>JumpToConflictMarker(0)<cr>

nnoremap <silent> [A :first<cr>
nnoremap <silent> [a :previous<cr>
nnoremap <silent> ]a :next<cr>
nnoremap <silent> ]A :last<cr>

nnoremap <silent> [B :bfirst<cr>
nnoremap <silent> [b :bprevious<cr>
nnoremap <silent> ]b :bnext<cr>
nnoremap <silent> ]B :blast<cr>

nnoremap yow :set wrap!<cr>:set wrap?<cr>
nnoremap yos :set spell!<cr>:set spell?<cr>
nnoremap yod :diffthis<cr>
nnoremap yon :set number!<cr>:set number?<cr>
nnoremap yor :set relativenumber!<cr>:set relativenumber?<cr>
nnoremap yom :<c-u>call ToggleMakeOnSaveFT()<cr>

function! s:ToggleBG()
    if &background == 'light'
        set background=dark
    else
        set background=light
    endif
endfunction
nnoremap <silent> yob :call <sid>ToggleBG()<cr>

tnoremap § <esc>
tnoremap <esc> <c-\><c-n>
tnoremap <c-v> <c-\><c-n>pi

xnoremap <expr> I (mode() =~# '[vV]' ? '<c-v>^o^I' : 'I')
xnoremap <expr> A (mode() =~# '[vV]' ? '<c-v>0o$A' : 'A')

nnoremap gj i<c-j><esc>k$

" I need some finnish letters occasionally
let s:fin_keys_enabled = 0

function! s:ToggleKeys() abort
    if s:fin_keys_enabled == 1
        iunmap ;
        iunmap :
        iunmap '
        iunmap "

        cunmap ;
        cunmap :
        cunmap '
        cunmap "
        let s:fin_keys_enabled = 0
        echo '[FinKeys] off'
    else
        inoremap ; ö
        inoremap : Ö
        inoremap ' ä
        inoremap " Ä

        cnoremap ; ö
        cnoremap : Ö
        cnoremap ' ä
        cnoremap " Ä
        let s:fin_keys_enabled = 1
        echo '[FinKeys] on'
    endif
endfunction

inoremap <silent> <c-l> <c-o>:call <sid>ToggleKeys()<cr>
nnoremap <silent> <c-l> :call <sid>ToggleKeys()<cr>
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
set path=.,,
set include=
set keywordprg=
set nrformats+=alpha
set formatoptions+=r

set clipboard=unnamed,unnamedplus

set pumheight=10
set completeopt=menu,menuone,noselect

" Commands without remembering case. Useful for plugin commands
set ignorecase smartcase

" Show replacement
set inccommand=split
set wildignore+=*/node_modules/*,*/__pycache__/,*/venv/*,*.pyc,.git/*

set smartindent
set hlsearch
" Clear highlighting on esc
nnoremap <silent><esc> :let @/ = ""<cr><esc>
nnoremap <silent>§ :let @/ = ""<cr><esc>

set undofile
set noswapfile

set updatetime=1000
set foldmethod=marker

set scrolloff=5

set shiftwidth=4
set softtabstop=-1
set expandtab

set matchpairs+=<:>

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

autocmd vimrc BufLeave,InsertEnter * set nocursorline
autocmd vimrc BufEnter,InsertLeave * set cursorline

" Disable stuff that will accidentally trap you
nnoremap Q <nop>
nnoremap q: <nop>
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
" Section: Appearance {{{
set synmaxcol=200
set termguicolors

function! PasteForStatusline() abort
    return &paste == 1 ? '[PASTE]' : ""
endfunction

set laststatus=2
set statusline=\ %f\ %*\ %r\ %m%{PasteForStatusline()}%=\ %{&ft}\ \|\ %l/%L\ :\ %c\ %<%*
" }}}
" Section: Plugins {{{
call plug#begin(g:vimdir . '/plugged')
" Color schemes
Plug 'sainnhe/sonokai'
Plug 'NLKNguyen/papercolor-theme'
Plug 'cideM/yui'
Plug 'n00bmind/retro-minimal'
Plug 'seesleestak/duo-mini'
Plug 'junegunn/seoul256.vim'
Plug 'AlessandroYorba/Alduin'

" Fuzzy find
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-commentary'               " Commenting
Plug 'tpope/vim-fugitive'                 " Git integration
Plug 'justinmk/vim-dirvish'               " Managing files (netrw is buggy)
Plug 'machakann/vim-sandwich'             " Surround objects
Plug 'mbbill/undotree'                    " Undo tree (undolist is too hard)
Plug 'godlygeek/tabular'                  " Align stuff
Plug 'romainl/vim-qf'                     " Better quickfix
Plug 'ajh17/VimCompletesMe'               " Completion

" nvim-0.5
if has('nvim-0.5')
    Plug 'neovim/nvim-lspconfig'
endif

if has('nvim-0.6')
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
endif

" Syntax
Plug 'pearofducks/ansible-vim'
Plug 'MaxMEllon/vim-jsx-pretty'
call plug#end()
" }}}
" Section: Plugin configuration {{{
" Plugin: nvim-lsp + snippets {{{
if has('nvim-0.5')
    lua require('lsp')

    " Save cursor position on format
    function! LspFormat() abort
        let view = winsaveview()
        lua vim.lsp.buf.formatting_sync()
        call winrestview(view)
    endfunction

    sign define LspDiagnosticsSignError text=! texthl=LspDiagnosticsSignError
    sign define LspDiagnosticsSignWarning text=! texthl=LspDiagnosticsSignWarning
    sign define LspDiagnosticsSignInformation text=- texthl=LspDiagnosticsSignInformation
    sign define LspDiagnosticsSignHint text=- texthl=LspDiagnosticsSignHint

    " nvim 0.6
    sign define DiagnosticSignError text=! texthl=DiagnosticSignError
    sign define DiagnosticSignWarn text=! texthl=DiagnosticSignWarn
    sign define DiagnosticSignInfo text=- texthl=DiagnosticSignInfo
    sign define DiagnosticSignHint text=- texthl=LspDiagnosticSignHint
endif
" }}}
" Plugin: nvim-treesitter {{{
if has('nvim-0.6')
    lua require('treesitter')
endif
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
nmap <A-q> <plug>(qf_qf_toggle)
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

let g:fzf_preview_window = ['right:hidden', 'ctrl-/']

if !exists('$FZF_DEFAULT_OPTS')
    let $FZF_DEFAULT_OPTS="--bind 'tab:down' --bind 'btab:up' --exact --reverse"
endif
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
nnoremap <silent><leader>g :vertical Git<CR>
" }}}
" Plugin: vim-sandwich {{{
runtime macros/sandwich/keymap/surround.vim
call operator#sandwich#set('all', 'all', 'highlight', 1)
" }}}
" }}}
" Section: Filetypes {{{
autocmd vimrc BufNewFile,BufRead *.yang set ft=yang
" }}}
" Section: Colorscheme {{{
function! NvimLspHL()
    highlight! LspDiagnosticsSignError ctermbg=1 ctermfg=10 guibg=#ff3399 guifg=#393939
    highlight! LspDiagnosticsSignWarning ctermfg=10 ctermbg=3 guifg=#393939 guibg=#ffcc66
    highlight! LspDiagnosticsSignInformation ctermfg=6 ctermbg=10 guibg=#66cccc guifg=#393939
    highlight! LspDiagnosticsSignHint ctermfg=6 ctermbg=10 guibg=#66ccff guifg=#393939

    " nvim 0.6
    highlight! DiagnosticSignError ctermbg=1 ctermfg=10 guibg=#ff3399 guifg=#393939
    highlight! DiagnosticSignWarn ctermfg=10 ctermbg=3 guifg=#393939 guibg=#ffcc66
    highlight! DiagnosticSignInfo ctermfg=6 ctermbg=10 guibg=#66cccc guifg=#393939
    highlight! DiagnosticSignHint ctermfg=6 ctermbg=10 guibg=#66ccff guifg=#393939

    highlight! link LspDiagnosticsUnderlineError SpellBad
    highlight! link LspDiagnosticsUnderlineWarning DiffChange
    highlight! LspDiagnosticsUnderlineInformation cterm=NONE gui=NONE
    highlight! LspDiagnosticsUnderlineHint cterm=NONE gui=NONE
endfunction
autocmd vimrc ColorScheme * call NvimLspHL()

function! PaperColorMod()
    if &background == 'light'
        highlight! SignColumn guibg=#e1e1e1
    endif
endfunction
autocmd vimrc ColorScheme PaperColor call PaperColorMod()

function! SonokaiColorMod()
    highlight! SignColumn guibg=#33353f
    highlight! LineNr guibg=#33353f
    highlight! VertSplit guifg=#555560
endfunction
autocmd vimrc ColorScheme sonokai call SonokaiColorMod()

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
colorscheme alduin
" }}}
" Section: Local settings {{{
execute 'silent! source' . g:vimdir . '/init.vim.local'
" }}}
