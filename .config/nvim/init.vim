" Setup {{{
let g:vimdir = stdpath('config')
let g:python3_host_prog = '/usr/bin/python3'

" Install vim-plug
if empty(glob(g:vimdir . '/autoload/plug.vim'))
  execute 'silent !curl -fLo ' . g:vimdir . '/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
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
xnoremap < <gv
xnoremap > >gv

nnoremap <leader>S :source <c-r>%<CR>
nnoremap <leader>q :q<CR>
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

nnoremap <silent> [[ m':call search(&define, 'bW')<cr>
nnoremap <silent> ]] m':call search(&define, "W")<CR>

set pastetoggle=<F2>

nnoremap <c-p> :find<space>
nmap <leader>h :oldfiles<cr>
nmap <leader>b :buffers<cr>
nmap <leader>l ://#<left><left>

" make list-like commands more intuitive
function! CCR()
    let cmdline = getcmdline()
    if getcmdtype() == ":"
      if cmdline =~ '\v\C^(ls|files|buffers)'
          " like :ls but prompts for a buffer command
          return "\<CR>:b"
      elseif cmdline =~ '\v\C/(#|nu|num|numb|numbe|number)$'
          " like :g//# but prompts for a command
          return "\<CR>:"
      elseif cmdline =~ '\v\C^(dli|il)'
          " like :dlist or :ilist but prompts for a count for :djump or :ijump
          return "\<CR>:" . cmdline[0] . "j  " . split(cmdline, " ")[1] . "\<S-Left>\<Left>"
      elseif cmdline =~ '\v\C^(cli|lli)'
          " like :clist or :llist but prompts for an error/location number
          return "\<CR>:sil " . repeat(cmdline[0], 2) . "\<Space>"
      elseif cmdline =~ '\C^old'
          " like :oldfiles but prompts for an old file to edit
          set nomore
          return "\<CR>:sil se more|e #<"
      elseif cmdline =~ '\C^changes'
          " like :changes but prompts for a change to jump to
          set nomore
          return "\<CR>:sil se more|norm! g;\<S-Left>"
      elseif cmdline =~ '\C^ju'
          " like :jumps but prompts for a position to jump to
          set nomore
          return "\<CR>:sil se more|norm! \<C-o>\<S-Left>"
      elseif cmdline =~ '\C^marks'
          " like :marks but prompts for a mark to jump to
          return "\<CR>:norm! `"
      elseif cmdline =~ '\C^undol'
          " like :undolist but prompts for a change to undo
          return "\<CR>:u "
      endif
    endif
    return "\<CR>"
endfunction
cnoremap <expr> <CR> CCR()
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

" Completion
set pumheight=10
set completeopt=noselect,menuone,menu
set omnifunc=syntaxcomplete#Complete

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

set scrolloff=5
set sidescrolloff=10
" }}}
" Commands {{{
command! -nargs=0 Config execute ':edit ' . $MYVIMRC
nnoremap <leader>c :Config<CR>

command! -nargs=? -complete=filetype EditFileTypePlugin
      \ execute 'keepj vsplit ' . g:vimdir . '/after/ftplugin/' .
      \ (empty(<q-args>) ? &ft : <q-args>) . '.vim'
nnoremap <localleader>c :EditFileTypePlugin<cr>

" Sane path {{{
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
Plug 'cideM/yui'

Plug 'christoomey/vim-tmux-navigator'     " Move between tmux and vim splits
Plug 'tmux-plugins/vim-tmux-focus-events' " Fix tmux focus events

" Fuzzy find
" Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'

Plug 'tpope/vim-commentary'               " Commenting
Plug 'tpope/vim-fugitive'                 " Git integration
Plug 'tpope/vim-unimpaired'               " Bindings
Plug 'tpope/vim-sleuth'                   " Wise indent style
" Plug 'tpope/vim-endwise'                  " End structures

" Plug '9mm/vim-closer'                     " End brackets
Plug 'justinmk/vim-dirvish'               " Managing files (netrw is buggy)
Plug 'romainl/vim-qf'                     " Quickfix window overall improvements
Plug 'machakann/vim-sandwich'             " Surround objects
Plug 'mbbill/undotree'                    " Undo tree (undolist is too hard)
Plug 'godlygeek/tabular'                  " Align stuff
Plug 'duggiefresh/vim-easydir'            " Automatically create directories

Plug 'neovim/nvim-lsp'
Plug 'haorenW1025/completion-nvim'
Plug 'haorenW1025/diagnostic-nvim'

" Syntax
" Plug 'pearofducks/ansible-vim'
" Plug 'maxmellon/vim-jsx-pretty'
" Plug 'rust-lang/rust.vim'
" Plug 'vim-python/python-syntax'
call plug#end() " }}}
" Plugin configuration {{{
" nvim-lsp {{{
lua << EOF
  local nvim_lsp = require('nvim_lsp')

  local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    require'diagnostic'.on_attach()
    require'completion'.on_attach()

    -- Mappings.
    local opts = { noremap=true, silent=true }
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gD'        , '<Cmd>lua vim.lsp.buf.declaration()<CR>'            , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gd'        , '<Cmd>lua vim.lsp.buf.definition()<CR>'             , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'K'         , '<Cmd>lua vim.lsp.buf.hover()<CR>'                  , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gi'        , '<cmd>lua vim.lsp.buf.implementation()<CR>'         , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , '<C-k>'     , '<cmd>lua vim.lsp.buf.signature_help()<CR>'         , opts)
    -- vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>D' , '<cmd>lua vim.lsp.buf.type_definition()<CR>'        , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gR'        , '<cmd>lua vim.lsp.buf.rename()<CR>'                 , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , 'gr'        , '<cmd>lua vim.lsp.buf.references()<CR>'             , opts)
    vim.api.nvim_buf_set_keymap(bufnr    , 'n' , '<leader>F' , '<cmd>lua vim.lsp.buf.formatting()<CR>'             , opts)
    -- vim.api.nvim_buf_set_keymap(bufnr , 'n' , '<leader>e' , '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>' , opts)
  end

  local servers = {'bashls', 'diagnosticls', 'tsserver', 'pyls', 'rls', 'vimls'}
  for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
      on_attach = on_attach,
    }
  end
EOF

" <c-w>p to jump to floating window
let g:completion_chain_complete_list = {
      \ 'default': [
      \     {'complete_items': ['lsp']},
      \     {'complete_items': ['path'], 'triggered_only': ['/']},
      \     {'mode': '<c-p>'},
      \     {'mode': '<c-n>'}
      \ ],
      \ 'comment': []
      \ }

" let g:completion_enable_snippet = 'UltiSnips'
let g:completion_auto_change_source = 1
let g:completion_trigger_character = ['.', '::', '/']
let g:completion_enable_auto_hover = 0
let g:completion_enable_fuzzy_match = 1
let g:diagnostic_enable_virtual_text = 0
let g:completion_trigger_keyword_length = 3
" }}}
" undotree {{{
let g:undotree_SplitWidth = 35
let g:undotree_DiffAutoOpen = 0
let g:undotree_SetFocusWhenToggle = 1
nnoremap <leader>u :UndotreeToggle<cr>
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
tnoremap <silent> <c-h> <C-\><C-n>:TmuxNavigateLeft<cr>
tnoremap <silent> <c-j> <C-\><C-n>:TmuxNavigateDown<cr>
tnoremap <silent> <c-k> <C-\><C-n>:TmuxNavigateUp<cr>
tnoremap <silent> <c-l> <C-\><C-n>:TmuxNavigateRight<cr>
" }}}
" vim-fugitive {{{
nnoremap <silent><leader>g :vertical Gstatus<CR>
" }}}
" vim-sandwich {{{
runtime macros/sandwich/keymap/surround.vim
" }}}
" colorscheme {{{
let g:python_highlight_all = 1
set background=light
let g:yui_comments = 'emphasize'
autocmd MyAutocmds ColorScheme * highlight Folded guifg=#777777 guibg=#e1e1e1
colorscheme yui
" }}}
" }}}
" Local settings {{{
let s:vimrc_local = fnamemodify(resolve(expand('<sfile>:p')), ':h').'/vimrc_local'
if filereadable(s:vimrc_local)
  execute 'source' s:vimrc_local
endif
" }}}
