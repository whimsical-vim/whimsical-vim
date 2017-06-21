" # Global settings
filetype plugin indent on
runtime! macros/matchit.vim
syntax on

set encoding=utf-8
:scriptencoding utf-8
set backspace=2
set clipboard=unnamed
set completeopt+=longest
set completeopt-=preview
set cursorline
set expandtab
set hidden
set history=1000
set hlsearch
set inccommand=nosplit
set incsearch
set laststatus=2
set mouse=a
set nobackup
set noswapfile
set number
set omnifunc=syntaxcomplete#Complete
set scrolloff=1
set shell=/bin/bash                                             " required by gitgutter plugin
set shiftround
set shiftwidth=2
let &showbreak = '↪ '
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
set path=**
let g:netrw_liststyle=1

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
let g:deoplete#enable_at_startup = 1
let g:EditorConfig_exclude_patterns = ['.git/COMMIT_EDITMSG']
let g:elm_format_autosave = 0
let g:elm_make_show_warnings = 1
let g:fzf_layout = { 'window': 'enew' }
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '!'
let g:ale_statusline_format = ['✗ %d', '! %d', '✓']
let g:elm_setup_keybindings = 0
let g:ale_linters = { 'haskell': ['hdevtools'] }
let g:test#strategy = 'neoterm'

" # Misc configuration
hi Comment cterm=italic

if !isdirectory(expand(&undodir))
   call mkdir(expand(&undodir), 'p')
endif

function! ExecuteMacroOverVisualRange()
  echo '@'.getcmdline()
  execute ":'<,'>normal @".nr2char(getchar())
endfunction

" # Mappings
let g:mapleader=' '
let g:maplocalleader='\'

xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

" Smart redraw (also clears current search highlighting)
nnoremap <silent> <leader>l :nohlsearch<cr>:diffupdate<cr>:syntax sync fromstart<cr><c-l>

" Perform fuzzy file searching
nnoremap <C-P> mN:Files<cr>
nnoremap <C-B> mN:Buffers<CR>
nnoremap <leader><leader> mN:Commands<cr>
nnoremap <leader>/ mN:Lines<cr>

" Terminal
nnoremap <silent> <leader>cc :call neoterm#toggle()<cr>
nnoremap <silent> <leader>co :call neoterm#open()<cr>
nnoremap <silent> <leader>ch :call neoterm#close()<cr>
nnoremap <silent> <leader>cl :call neoterm#clear()<cr>
nnoremap <silent> <leader>ck :call neoterm#kill()<cr>

" Hightlight all incremental search results
map /  <plug>(incsearch-forward)
map ?  <plug>(incsearch-backward)
map g/ <plug>(incsearch-stay)

" Terminal mappings
nnoremap <silent> <C-T> :Ttoggle<cr>
tnoremap <silent> <C-T> <C-\><C-n>:Ttoggle<cr>
tnoremap <C-[> <C-\><C-n>
tnoremap <C-O> <C-\><C-n>`N

" tabs
nnoremap <leader>tt :tabnew<cr>
nnoremap <leader>tc :tabclose<cr>

" git
nnoremap <leader>gs :Gstatus<cr>
nnoremap <leader>gd :Gdiff<cr>

" # Autocmds
augroup customCommands
  autocmd!
  autocmd FileType markdown nnoremap <localleader>m :LivedownToggle<cr>
  autocmd FileType javascript nnoremap <localleader>c :JSContextColorToggle<cr>
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.sjs set filetype=javascript
  autocmd WinEnter term://* startinsert
  autocmd BufLeave *;#FZF silent! BD!
  " Sort files in buffer, but keep the cursor on the file we came from.
  autocmd BufWritePre * :%s/\s\+$//e  " automatically remove trailing whitespace on writing
  " Elm key bindings
  au FileType elm nmap <buffer> <localleader>m <Plug>(elm-make)
  au FileType elm nmap <buffer> <localleader>M <Plug>(elm-make-main)
  au FileType elm nmap <buffer> <localleader>t <Plug>(elm-test)
  au FileType elm nmap <buffer> <localleader>r <Plug>(elm-repl)
  au FileType elm nmap <buffer> <localleader>d <Plug>(elm-show-docs)
  au FileType elm nmap <buffer> <localleader>D <Plug>(elm-browse-docs)
  nmap <silent> <localleader>e <Plug>(ale_detail)
  nmap <silent> <localleader>s :TestNearest<CR>
  nmap <silent> <localleader>t :TestFile<CR>
  nmap <silent> <localleader>a :TestSuite<CR>
  nmap <silent> <localleader>l :TestLast<CR>
  nmap <silent> <localleader>g :TestVisit<CR>
  autocmd VimEnter *
  \ command! -bang -nargs=* Ag
  \ call fzf#vim#ag(<q-args>, '', { 'options': '--bind ctrl-a:select-all,ctrl-d:deselect-all' }, <bang>0)
  autocmd BufWritePre *.elm Neoformat
  autocmd BufWritePre *.hs Neoformat
  autocmd BufWritePre *.js Neoformat
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


" # Plugins
function! BrangelinaPlugins()
  Plug 'Shougo/deoplete.nvim'                "  Code completion
  Plug 'airblade/vim-gitgutter'              "  Column with line changes
  Plug 'amiorin/vim-fenced-code-blocks'      "  Edit code in Markdown code blocks
  Plug 'bronson/vim-visual-star-search'      "  Easily search for the selected text
  Plug 'editorconfig/editorconfig-vim'       "  Settings based on .editorconfig file
  Plug 'elentok/todo.vim'                    "  Todo.txt support
  Plug 'elmcast/elm-vim'                     "  Elm language syntac
  Plug 'godlygeek/tabular'                   "  align stuff
  Plug 'haya14busa/incsearch.vim'            "  Improved incremental searching
  Plug 'idris-hackers/idris-vim'             "  Idris support
  Plug 'itchyny/lightline.vim'               "  Status bar
  Plug 'janko-m/vim-test'                    "  run tests async
  Plug 'junegunn/fzf'                        "  Fuzzy file searching
  Plug 'junegunn/fzf.vim'                    "  vim bindings for fzf
  Plug 'junegunn/vader.vim'                  "  vim test framework
  Plug 'justinmk/vim-sneak'                  "  Medium-range motion
  Plug 'kassio/neoterm'                      "  Wrapper of some neovim's :terminal functions.
  Plug 'qpkorr/vim-bufkill'                  "  Kill a buffer without closing its window
  Plug 'sbdchd/neoformat'
  Plug 'sheerun/vim-polyglot'                "  Combines a whole bunch of vim syntax packs
  Plug 'slashmili/alchemist.vim'             "  mix integration for elixir
  Plug 'stefandtw/quickfix-reflector.vim'    "  Make quickfix window editable
  Plug 'tommcdo/vim-exchange'                "  text exchange operator
  Plug 'tommcdo/vim-exchange'                "  text exchange operator
  Plug 'tpope/vim-abolish'                   "  Working with variants of a world
  Plug 'tpope/vim-commentary'                "  (Un)commenting lines
  Plug 'tpope/vim-eunuch'                    "  Unix commands
  Plug 'tpope/vim-fugitive'                  "  GIT integration
  Plug 'tpope/vim-jdaddy'                    "  JSON manipulation commands
  Plug 'tpope/vim-repeat'                    "  Use dot operator with plugins
  Plug 'tpope/vim-sleuth'                    "  Detect indent style from a file
  Plug 'tpope/vim-speeddating'               "  Manipulation of date strings
  Plug 'tpope/vim-surround'                  "  Commands to work with surroundings
  Plug 'tpope/vim-unimpaired'                "  Miscellaneous commands
  Plug 'tpope/vim-vinegar'                   " netrw replacement
  Plug 'troydm/zoomwintab.vim'               "  zoom windows with <c-w>o
  Plug 'vim-scripts/CursorLineCurrentWindow' "  Only show the cursorline in the active window
  Plug 'w0rp/ale'                            "  Asynchronous linter
endfunction
