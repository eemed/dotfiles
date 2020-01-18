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
set guifont=Hack:h13
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

Plug 'eemed/sitruuna.vim'                       " Colorscheme

Plug 'wellle/targets.vim'                       " More text objects

Plug 'tpope/vim-surround'                       " Surround objects
Plug 'tpope/vim-repeat'                         " Repeat surround
Plug 'tpope/vim-commentary'                     " Commenting
Plug 'tpope/vim-fugitive'                       " Git integration
Plug 'tpope/vim-unimpaired'                     " Bindings
Plug 'tpope/vim-vinegar'                        " Netrw
Plug 'tpope/vim-eunuch'                         " Basic unix commands
Plug 'tpope/vim-sleuth'                         " Wise indenting
Plug 'tpope/vim-dispatch'                       " Async jobs

Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'                         " Fyzzy find anything you want
Plug 'junegunn/vim-easy-align'                  " Align stuff

Plug 'ludovicchabant/vim-gutentags'             " Tags
Plug 'mbbill/undotree'                          " Undotree visualizer
Plug 'norcalli/nvim-colorizer.lua'              " Colors

" Plug 'chemzqm/vim-jsx-improve'
" Plug 'vim-python/python-syntax'
" Plug 'vim-erlang/vim-erlang-runtime'
" Plug 'neovimhaskell/haskell-vim'
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
nnoremap <silent><leader>g :G<CR> <c-w>L
" }}}

" fzf.vim {{{
function! Browse()
    if len(fugitive#head()) > 1
        call fzf#run(fzf#wrap({'source': 'git ls-files --exclude-standard --others --cached'}))
    else
        exe "Files"
    endif
endfunction

nnoremap <silent><leader>F :Files<CR>
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

if executable('rg')
  let g:gutentags_file_list_command = 'rg --files'
endif
" }}}

" vim-easy-align {{{
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)
" }}}

" undotree {{{
nnoremap <silent><leader>u :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 0
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
" find it using ? or / select it and use these bindings
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

set pastetoggle=<F2>
" }}}

" Basic {{{
filetype plugin indent on
set hidden
set laststatus=2
set splitright
set mouse=a
set nowrap
set list listchars=tab:\ \ ,nbsp:•,trail:•
set autoread
set showmatch
set ignorecase
set inccommand=split

set path+=**
set clipboard=unnamedplus

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
" }}}

" Appearance {{{
colorscheme sitruuna
set cursorline
let &colorcolumn=join(range(101,999), ",")     " 100 char columns
set termguicolors
set t_Co=256
" }}}

" Statusline {{{
function! GitStatus()
    return fugitive#head() == '' ? '' : fugitive#head()
endfunction

function! PasteForStatusline()
    return &paste == 1 ? '[PASTE]' : ""
endfunction

set laststatus=2
set statusline=
set statusline+=\ ‹‹
set statusline+=\ %f
set statusline+=\ ››
set statusline+=\ %*
set statusline+=\ %r
set statusline+=%m
set statusline+=%{PasteForStatusline()}
set statusline+=\ %{gutentags#statusline()}
set statusline+=%=
set statusline+=\ %{GitStatus()}
set statusline+=\ ‹‹
set statusline+=\ %{&ft}
set statusline+=\ ::
set statusline+=\ %l/%L\ :\ %c
set statusline+=\ %*
set statusline+=››\ %*
" }}}

" Autocommands {{{
augroup basic
  autocmd!
  autocmd FocusLost,BufLeave * silent! update
augroup end
" }}}
