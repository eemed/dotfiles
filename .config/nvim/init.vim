"    (_)___  (_) /__   __(_)___ ___
"   / / __ \/ / __/ | / / / __ `__ \
"  / / / / / / /__| |/ / / / / / / /
" /_/_/ /_/_/\__(_)___/_/_/ /_/ /_/
"
"
" Configurable {{{
let mapleader = "\ "  " Space leader
let g:dark_theme = 'sitruuna'
let g:light_theme = 'base16-classic-light'
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

Plug 'eemed/sitruuna.vim'
Plug 'chriskempson/base16-vim'                  " Colorscheme
Plug 'mhinz/vim-startify'                       " Nice start screen

Plug 'tmsvg/pear-tree'                          " Complete pairs
Plug 'norcalli/nvim-colorizer.lua'              " Hex colors

Plug 'wellle/targets.vim'                       " More text objects
Plug 'editorconfig/editorconfig-vim'

Plug 'tpope/vim-surround'                       " Surround objects
Plug 'tpope/vim-repeat'                         " Repeat surround
Plug 'tpope/vim-commentary'                     " Commenting
Plug 'tpope/vim-fugitive'                       " Git integration
Plug 'tpope/vim-unimpaired'                     " Bindings
Plug 'tpope/vim-vinegar'                        " Netrw
Plug 'tpope/vim-eunuch'                         " Basic unix commands

Plug 'neomake/neomake'                          " Linting + async jobs
Plug 'mattn/emmet-vim'                          " Emmet
Plug 'SirVer/ultisnips'                         " Snippets
Plug 'honza/vim-snippets'

Plug 'Shougo/denite.nvim', { 'do': ':UpdateRemotePlugins' }

Plug 'ludovicchabant/vim-gutentags'
Plug 'mbbill/undotree'
Plug 'junegunn/vim-easy-align'

Plug 'chemzqm/vim-jsx-improve'
Plug 'vim-python/python-syntax'
Plug 'vim-erlang/vim-erlang-runtime'
Plug 'neovimhaskell/haskell-vim'
call plug#end()
" }}}

" Plugin configuration {{{
" ultisnips {{{
let g:UltiSnipsExpandTrigger       = "<tab>"
let g:UltiSnipsJumpForwardTrigger  = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-Tab>"
let g:UltiSnipsSnippetsDir         = "~/.config/nvim/ultisnips"
let g:UltiSnipsSnippetDirectories  = ["ultisnips"]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
" }}}

" vim-startify {{{
let g:startify_custom_header = [
            \ "                           _           ",
            \ "     _ __   ___  _____   _(_)_ __ ___  ",
            \ "    | '_ \\ / _ \\/ _ \\ \\ / / | '_ ` _ \\ ",
            \ "    | | | |  __/ (_) \\ V /| | | | | | |",
            \ "    |_| |_|\\___|\\___/ \\_/ |_|_| |_| |_|",
            \ ]

let g:startify_bookmarks = [ {'c': '~/.config/nvim/init.vim'}, {'b': '~/.bashrc'} ]
" }}}

" vim-fugitive {{{
nnoremap <silent><leader>g :G<CR> <c-w>L
" }}}

" emmet.vim {{{
let g:user_emmet_install_global = 0
let g:user_emmet_leader_key     = ','
" Enable emmet
autocmd FileType php,xml,html,css,javascript.jsx,html* EmmetInstall
" }}}

" neomake {{{
nnoremap <silent> m<cr> :Neomake<CR>
nnoremap <silent> M<cr> :Neomake!<CR>
nnoremap m? :echom &makeprg<CR>

let g:neomake_go_enabled_makers     = ['golint', 'go']
let g:neomake_python_enabled_makers = ['flake8', 'python']

let g:neomake_error_sign = {
   \ 'text': '‼',
   \ 'texthl': 'NeomakeErrorSign',
   \ }
let g:neomake_warning_sign = {
   \   'text': '!',
   \   'texthl': 'NeomakeWarningSign',
   \ }
let g:neomake_message_sign = {
    \   'text': '>',
    \   'texthl': 'NeomakeMessageSign',
    \ }
let g:neomake_info_sign = {
    \ 'text': 'i',
    \ 'texthl': 'NeomakeInfoSign'
    \ }
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

" pear-tree {{{
let g:pear_tree_repeatable_expand = 0
let g:pear_tree_smart_openers     = 1
let g:pear_tree_smart_closers     = 1
let g:pear_tree_smart_backspace   = 1
let g:pear_tree_map_special_keys  = 0
" }}}

" vim-easy-align {{{
xmap ga <Plug>(LiveEasyAlign)
nmap ga <Plug>(LiveEasyAlign)
" }}}

" undotree {{{
nnoremap <silent><leader>u :UndotreeToggle<CR>
let g:undotree_DiffAutoOpen = 0
" }}}

" python-syntax {{{
let g:python_highlight_all = 1
" }}}

" denite {{{
call denite#custom#alias('source', 'file/rec/git', 'file/rec')
call denite#custom#var('file/rec/git', 'command',
            \ ['git', 'ls-files', '-co', '--exclude-standard'])
nnoremap <silent> <C-p> :<C-u>Denite
            \ `finddir('.git', ';') != '' ? 'file/rec/git' : 'file/rec'`<CR>
nnoremap <silent><leader>b :Denite buffer<CR>

function! s:denite_quickfix_grep()
    :Denite grep
    call denite#call_map('toggle_select_all')
    call denite#call_map('do_action', 'quickfix')
endfunction
command! -nargs=0 Dgrep call <sid>denite_quickfix_grep()<CR>

if executable('rg')
	" Ripgrep command on grep source
	call denite#custom#var('grep', 'command', ['rg'])
	call denite#custom#var('grep', 'default_opts',
			\ ['-i', '--vimgrep', '--no-heading'])
	call denite#custom#var('grep', 'recursive_opts', [])
	call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
	call denite#custom#var('grep', 'separator', ['--'])
	call denite#custom#var('grep', 'final_opts', [])
endif

let s:denite_options = {
      \ 'prompt' : '❯',
      \ 'start_filter': 1,
      \ 'auto_resize': 1,
      \ 'source_names': 'short',
      \ 'direction': 'botright',
      \ 'highlight_filter_background': 'StatusLine',
      \ 'highlight_matched_char': 'Statement',
      \ 'reversed': 'true',
      \ }
call denite#custom#option('default', s:denite_options)
" }}}
" }}}

" Keybindings {{{
nnoremap Y y$
nnoremap <tab> za

" Move text
xnoremap J :move '>+1<CR>gv=gv
xnoremap K :move '<-2<CR>gv=gv
xnoremap < <gv
xnoremap > >gv

nnoremap <silent><leader>q :q<CR>

nnoremap <leader>x :silent exec "! chmod +x %"<CR>
nnoremap <leader>a ggVG
nnoremap <leader>f :copen<cr>
nnoremap <leader>l :lopen<cr>

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
vnoremap <silent><c-s> <Esc>:update<CR>

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
nnoremap <leader>S mz:%s/\s\+$//e<CR>`zzz
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

" Faster grepping
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
endif

set omnifunc=syntaxcomplete#Complete
" }}}

" Commands {{{
command! -nargs=0 ConfigVs execute ':vsplit' . config
command! -nargs=0 Config execute ':edit' . config
nnoremap <leader>c :ConfigVs<CR>

" Recursively create directories to the new file
command! -nargs=1 E execute('silent! !mkdir -p "$(dirname "<args>")"') <Bar> e <args>

" List highlight groups
nmap <leader>sp :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

" Navigate to the next fold
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

" Appearance {{{
if isdirectory($HOME . "/.config/nvim/plugged")
  if exists("$VIM_THEME") && $VIM_THEME == "light"
    execute 'colorscheme ' . g:light_theme
  else
    execute 'colorscheme ' . g:dark_theme
  endif

  set cursorline
  let &colorcolumn=join(range(101,999), ",")     " 100 char columns
  set termguicolors
  set t_Co=256

  function! CustomAppearance()
  endfunction
  call CustomAppearance()
endif
" }}}

" Statusline {{{
function! GitStatus()
  let git = fugitive#head()
  if git != ''
    return git
  else
    return ''
  endif
endfunction

set laststatus=2
set statusline=
set statusline+=\ ‹‹
set statusline+=\ %f

set statusline+=\ ››
set statusline+=\ %*
set statusline+=\ %r
set statusline+=\ %m
set statusline+=%{gutentags#statusline()}
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
  autocmd! basic
  autocmd FocusLost,BufLeave * silent! update

  function! Swap()
    if g:colors_name ==? g:dark_theme
      execute 'colorscheme ' . g:light_theme
    else
      execute 'colorscheme ' . g:dark_theme
    endif
    call CustomAppearance()
  endfunction

  autocmd Signal * call Swap()
augroup end

augroup plugin
  autocmd! plugin

  " Fugitive, qf, help and godoc quitting
  autocmd FileType gitcommit,qf,help,godoc,goterm nnoremap <buffer> q :q!<CR><CR>
  autocmd FileType gitcommit,qf,help,fugitive set signcolumn=no
  autocmd FileType gitcommit nnoremap <buffer> <C-s> :wq<CR><CR>
augroup end
" }}}

" nvim 0.5 and LSP!! {{{
if has("nvim-0.5")
  " Needed plugin
  " Plug 'neovim/nvim-lsp'

  " Setup language servers in after/ftplugin/lang.vim like this
  " call nvim_lsp#setup("pyls", {})
  " set omnifunc=lsp#omnifunc
  "
  " Setup bindings to lsp functions shortcuts
  " :h lsp-vim-functions
endif
" }}}
