" # Global settings
filetype plugin indent on
syntax on

:scriptencoding utf-8
let &showbreak = '↪ '
set clipboard=unnamed
set completeopt+=longest
set completeopt-=preview
set cursorline
set expandtab
set hidden
set mouse=a
set noswapfile
set number
set path=**
set shell=/bin/bash " required by gitgutter plugin
set updatetime=100  " ensures gitgutter updates every 100ms
set shiftround
set shiftwidth=2
set splitbelow
set splitright
set tabstop=2
set termguicolors
set ttyfast " removed in nvim
set undodir=~/tmp/vim/undo
set undofile
set wildignorecase

" # Plugin configuration
let g:EditorConfig_exclude_patterns = ['.git/COMMIT_EDITMSG']
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#vimagit#enabled = 1
let g:airline_theme='atomic' " nice with almost all colorschemes
let g:ale_elm_make_use_global=1
let g:ale_linters = { 'haskell': ['hlint', 'hdevtools'] }
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '!'
let g:deoplete#enable_at_startup = 1
let g:elm_format_autosave = 0
let g:elm_make_show_warnings = 1
let g:elm_setup_keybindings = 0
let g:fzf_layout = { 'window': 'enew' }
let g:haskell_indent_disable=1 "Automatic indenting and hindent don't agree
let g:localvimrc_persistent=2 "See plugin: embear/vim-localvimrc
let g:neoterm_autoinsert = 1
let g:neoterm_autoscroll = 1
let g:neoterm_default_mod = 'tab'
let g:netrw_liststyle=1
let g:polyglot_disabled = ['haskell']
let g:startify_change_to_vcs_root = 1
let g:startify_session_delete_buffers = 1
let g:test#strategy = 'neoterm'
let $FZF_DEFAULT_OPTS .= ' --no-height' " fixes fzf in nvim terminals

if !isdirectory(expand(&undodir))
   call mkdir(expand(&undodir), 'p')
endif

" # Mappings
let g:mapleader=' '
let g:maplocalleader='\'

" global search
nnoremap <C-S> :Rg <C-R><C-W><CR>
vnoremap <C-S> "yy<esc>:Rg <C-R>y<CR>

" Perform fuzzy file searching
nnoremap <C-P> mN:Files<cr>
nnoremap <C-B> mN:Buffers<CR>
nnoremap <C-/> mN:Lines<cr>
nnoremap <leader><leader> mN:Commands<cr>
nnoremap <leader>/ mN:History/<cr>
nnoremap <leader>: mN:History:<cr>
nnoremap <leader>? mN:Helptags<cr>

" Autocompletion fzf
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file-ag)
imap <c-x><c-l> <plug>(fzf-complete-line)

" fzf yank
nnoremap <leader>y :FZFNeoyank<cr>
nnoremap <leader>Y :FZFNeoyank " P<cr>
vnoremap <leader>y :FZFNeoyankSelection<cr>

" Terminal mappings
nnoremap <silent> <C-T> :<c-u>exec v:count.'Ttoggle'<cr>
tnoremap <silent> <C-T> <C-\><C-n>:<c-u>exec v:count.'Ttoggle'<cr>
tnoremap <C-[> <C-\><C-n>
tnoremap <C-O> <C-\><C-n>`N


" Hightlight all incremental search results
map /  <plug>(incsearch-forward)
map ?  <plug>(incsearch-backward)
map g/ <plug>(incsearch-stay)

" git
nnoremap <C-g> :MagitOnly<cr>
nnoremap <C-h> :MerginalToggle<cr>

" nvim-completion-manager
" use <TAB> to select the popup menu
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" # Autocmds
augroup customCommands
  autocmd!
  " Elm key bindings
  autocmd FileType elm nmap <buffer> <localleader>m :ElmMake<cr>
  autocmd FileType elm nmap <buffer> <localleader>M :ElmMakeMain<cr>
  autocmd FileType elm nmap <buffer> <localleader>t :ElmTest<cr>
  autocmd FileType elm nmap <buffer> <localleader>r :ElmRepl<cr>
  autocmd FileType elm nmap <buffer> <localleader>d :ElmShowDocs<cr>
  autocmd FileType elm nmap <buffer> <localleader>D :ElmBrowseDocs<cr>
  autocmd FileType elm set tabstop=4
  autocmd FileType elm set shiftwidth=4
  nmap <silent> <localleader>e <Plug>(ale_detail)
  nmap <silent> <localleader>s :TestNearest<CR>
  nmap <silent> <localleader>t :TestFile<CR>
  nmap <silent> <localleader>a :TestSuite<CR>
  nmap <silent> <localleader>l :TestLast<CR>
  nmap <silent> <localleader>g :TestVisit<CR>
  autocmd BufWritePre * Neoformat
augroup END

" # Commands
command! ReloadConfig execute "source ~/.config/nvim/init.vim"

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>).'| tr -d "\017"', 1,
  \   { 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all' },
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, { 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all' }, <bang>0)

" # Plugins
function! BrangelinaPlugins()
  Plug 'ncm2/ncm2'
  if !has('nvim')
    Plug 'roxma/vim-hug-neovim-rpc'
  endif
  Plug 'Shougo/neoyank.vim'
  Plug 'airblade/vim-gitgutter'              "  Column with line changes
  Plug 'amiorin/vim-fenced-code-blocks'      "  Edit code in Markdown code blocks
  Plug 'arithran/vim-delete-hidden-buffers'
  Plug 'bronson/vim-visual-star-search'      "  Easily search for the selected text
  Plug 'editorconfig/editorconfig-vim'       "  Settings based on .editorconfig file
  Plug 'elentok/todo.vim'                    "  Todo.txt support
  Plug 'embear/vim-localvimrc'               "  Support project-specific vim configurations
  Plug 'godlygeek/tabular'                   "  align stuff
  Plug 'haya14busa/incsearch.vim'            "  Improved incremental searching
  Plug 'idanarye/vim-merginal'
  Plug 'idris-hackers/idris-vim'             "  Idris mode
  Plug 'janko-m/vim-test'                    "  run tests async
  Plug 'jreybert/vimagit'
  Plug 'junegunn/fzf'                        "  Fuzzy file searching
  Plug 'junegunn/fzf.vim'                    "  vim bindings for fzf
  Plug 'junegunn/goyo.vim'                   "  A no-chrome mode for conentrated writing
  Plug 'junegunn/vader.vim'                  "  vim test framework
  Plug 'justinhoward/fzf-neoyank'
  Plug 'kassio/neoterm'                      "  Wrapper of some neovim's :terminal functions.
  Plug 'machakann/vim-highlightedyank'
  Plug 'mhinz/vim-startify'                  " startup page
  Plug 'neovimhaskell/haskell-vim'           "  Better syntax-hihglighting for haskell
  Plug 'roxma/ncm-elm-oracle'
  Plug 'roxma/ncm-rct-complete'
  Plug 'sbdchd/neoformat'                    "  Automatic code formatting
  Plug 'sheerun/vim-polyglot'                "  Combines a whole bunch of vim syntax packs
  Plug 'stefandtw/quickfix-reflector.vim'    "  Make quickfix window editable
  Plug 'stoeffel/notes.vim'                  "  take notes
  Plug 'tommcdo/vim-exchange'                "  text exchange operator
  Plug 'tpope/vim-abolish'                   "  Working with variants of a world
  Plug 'tpope/vim-commentary'                "  (Un)commenting lines
  Plug 'tpope/vim-eunuch'                    "  Unix commands
  Plug 'tpope/vim-fugitive'                  "  GIT integration
  Plug 'tpope/vim-jdaddy'                    "  JSON manipulation commands
  Plug 'tpope/vim-repeat'                    "  Use dot operator with plugins
  Plug 'tpope/vim-rhubarb'                   "  Fugitive Github extension
  Plug 'tpope/vim-scriptease'
  Plug 'tpope/vim-sensible'                  " Defaults everyone can agree on
  Plug 'tpope/vim-speeddating'               "  Manipulation of date strings
  Plug 'tpope/vim-surround'                  "  Commands to work with surroundings
  Plug 'tpope/vim-unimpaired'                "  Miscellaneous commands
  Plug 'tpope/vim-vinegar'                   "  netrw replacement
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'vim-scripts/CursorLineCurrentWindow' "  Only show the cursorline in the active window
  Plug 'w0rp/ale'                            "  Asynchronous linter
endfunction
