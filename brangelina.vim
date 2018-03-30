" # Global settings
filetype plugin indent on
runtime! macros/matchit.vim
syntax on

:scriptencoding utf-8
let &showbreak = '↪ '
set backspace=2
set clipboard=unnamed
set completeopt+=longest
set completeopt-=preview
set cursorline
set encoding=utf-8
set expandtab
set hidden
set history=1000
set hlsearch
set incsearch
set laststatus=2
set mouse=a
set nobackup
set noswapfile
set number
set omnifunc=syntaxcomplete#Complete
set path=**
set scrolloff=1
set shell=/bin/bash                                             " required by gitgutter plugin
set shiftround
set shiftwidth=2
set smarttab
set splitbelow
set splitright
set tabstop=2
set termguicolors
set ttyfast
set undodir=~/tmp/vim/undo
set undofile
set wildignorecase
set wildmenu
set wildmode=full

" Theme
let g:lightline = {
  \   'active': {
  \     'left': [
  \       [ 'mode', 'paste' ],
  \       [ 'readonly', 'filename', 'modified', 'ale' ]
  \     ]
  \   },
  \   'component_function': {
  \     'ale': 'ALEGetStatusLine'
  \   }
  \ }

" # Plugin configuration
let g:EditorConfig_exclude_patterns = ['.git/COMMIT_EDITMSG']
let g:ale_elm_make_use_global=1
let g:ale_linters = { 'haskell': ['hlint', 'hdevtools'] }
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '!'
let g:ale_statusline_format = ['✗ %d', '! %d', '✓']
let g:asyncrun_open = 8
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

hi Comment cterm=italic

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
" `<C-_>` == `<C-/>` ¯\_(ツ)_/¯
nnoremap <C-_> mN:Lines<cr>
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
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>
nnoremap <leader>gg :Twiggy<cr>

" # Autocmds
augroup customCommands
  autocmd!
  autocmd FileType markdown nnoremap <localleader>m :LivedownToggle<cr>
  autocmd FileType javascript nnoremap <localleader>co :JSContextColorToggle<cr>
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.sjs set filetype=javascript
  " Sort files in buffer, but keep the cursor on the file we came from.
  autocmd BufWritePre * :%s/\s\+$//e  " automatically remove trailing whitespace on writing
  " Elm key bindings
  autocmd FileType elm nmap <buffer> <localleader>m <Plug>(elm-make)
  autocmd FileType elm nmap <buffer> <localleader>M <Plug>(elm-make-main)
  autocmd FileType elm nmap <buffer> <localleader>t <Plug>(elm-test)
  autocmd FileType elm nmap <buffer> <localleader>r <Plug>(elm-repl)
  autocmd FileType elm nmap <buffer> <localleader>d <Plug>(elm-show-docs)
  autocmd FileType elm nmap <buffer> <localleader>D <Plug>(elm-browse-docs)
  autocmd FileType elm set tabstop=4
  autocmd FileType elm set shiftwidth=4
  nmap <silent> <localleader>e <Plug>(ale_detail)
  nmap <silent> <localleader>s :TestNearest<CR>
  nmap <silent> <localleader>t :TestFile<CR>
  nmap <silent> <localleader>a :TestSuite<CR>
  nmap <silent> <localleader>l :TestLast<CR>
  nmap <silent> <localleader>g :TestVisit<CR>
  autocmd VimEnter *
  \ command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, '', { 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all' }, <bang>0)
  autocmd BufWritePre * Neoformat
augroup END

" # Commands
" reload .config/nvim/init.vim
command! ReloadConfig execute "source ~/.config/nvim/init.vim"
" close hidden buffers
command! -nargs=* Only call CloseHiddenBuffers()
function! CloseHiddenBuffers()
    " figure out which buffers are visible in any tab
    let l:visible = {}
    for l:t in range(1, tabpagenr('$'))
        for l:b in tabpagebuflist(l:t)
            let l:visible[l:b] = 1
        endfor
    endfor
    " close any buffer that are loaded and not visible
    let l:tally = 0
    for l:b in range(1, bufnr('$'))
        if bufloaded(l:b) && !has_key(l:visible, l:b)
            let l:tally += 1
            exe 'bw ' . l:b
        endif
    endfor
    echon 'Deleted ' . l:tally . ' buffers'
endfun

command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always '.shellescape(<q-args>).'| tr -d "\017"', 1,
  \   fzf#vim#with_preview({ 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-q:toggle-preview' },'up:60%'),
  \   <bang>0)

command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({ 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all,ctrl-q:toggle-preview' }, 'up:60%'), <bang>0)

" # Plugins
function! BrangelinaPlugins()
  Plug 'Shougo/deoplete.nvim'
  Plug 'Shougo/neoyank.vim'
  Plug 'airblade/vim-gitgutter'              "  Column with line changes
  Plug 'amiorin/vim-fenced-code-blocks'      "  Edit code in Markdown code blocks
  Plug 'bronson/vim-visual-star-search'      "  Easily search for the selected text
  Plug 'editorconfig/editorconfig-vim'       "  Settings based on .editorconfig file
  Plug 'elentok/todo.vim'                    "  Todo.txt support
  Plug 'elmcast/elm-vim'                     "  Elm language syntac
  Plug 'embear/vim-localvimrc'               "  Support project-specific vim configurations
  Plug 'godlygeek/tabular'                   "  align stuff
  Plug 'haya14busa/incsearch.vim'            "  Improved incremental searching
  Plug 'idris-hackers/idris-vim'             "  Idris mode
  Plug 'itchyny/lightline.vim'               "  Status bar
  Plug 'janko-m/vim-test'                    "  run tests async
  Plug 'junegunn/fzf'                        "  Fuzzy file searching
  Plug 'junegunn/fzf.vim'                    "  vim bindings for fzf
  Plug 'junegunn/goyo.vim'                   "  A no-chrome mode for conentrated writing
  Plug 'junegunn/vader.vim'                  "  vim test framework
  Plug 'justinhoward/fzf-neoyank'
  Plug 'justinmk/vim-sneak'                  "  Medium-range motion
  Plug 'kana/vim-textobj-user'               "  User-defined text objects
  Plug 'kassio/neoterm'                      "  Wrapper of some neovim's :terminal functions.
  Plug 'machakann/vim-highlightedyank'
  Plug 'mhinz/vim-startify'                  " startup page
  Plug 'nelstrom/vim-textobj-rubyblock'      "  Ruby-specific text objects
  Plug 'neovimhaskell/haskell-vim'           "  Better syntax-hihglighting for haskell
  Plug 'roxma/nvim-yarp'
  Plug 'roxma/vim-hug-neovim-rpc'
  Plug 'sbdchd/neoformat'                    "  Automatic code formatting
  Plug 'sheerun/vim-polyglot'                "  Combines a whole bunch of vim syntax packs
  Plug 'skywind3000/asyncrun.vim'
  Plug 'slashmili/alchemist.vim'             "  mix integration for elixir
  Plug 'sodapopcan/vim-twiggy'               "  fugitve extension to manage branches
  Plug 'stefandtw/quickfix-reflector.vim'    "  Make quickfix window editable
  Plug 'tommcdo/vim-exchange'                "  text exchange operator
  Plug 'tommcdo/vim-exchange'                "  text exchange operator
  Plug 'tpope/vim-abolish'                   "  Working with variants of a world
  Plug 'tpope/vim-commentary'                "  (Un)commenting lines
  Plug 'tpope/vim-eunuch'                    "  Unix commands
  Plug 'tpope/vim-fugitive'                  "  GIT integration
  Plug 'tpope/vim-jdaddy'                    "  JSON manipulation commands
  Plug 'tpope/vim-repeat'                    "  Use dot operator with plugins
  Plug 'tpope/vim-rhubarb'                   "  Fugitive Github extension
  Plug 'tpope/vim-speeddating'               "  Manipulation of date strings
  Plug 'tpope/vim-surround'                  "  Commands to work with surroundings
  Plug 'tpope/vim-unimpaired'                "  Miscellaneous commands
  Plug 'tpope/vim-vinegar'                   "  netrw replacement
  Plug 'troydm/zoomwintab.vim'               "  zoom windows with <c-w>o
  Plug 'vim-scripts/CursorLineCurrentWindow' "  Only show the cursorline in the active window
  Plug 'w0rp/ale'                            "  Asynchronous linter
endfunction
