scriptencoding utf-8
" Set POSIX compatible shell instead of fish
" {{{
if &shell =~# 'fish$'
    set shell=zsh
endif
" }}}

" Load vim-plug
" {{{
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimPlug VimEnter * PlugInstall --sync | source $MYVIMRC
endif
" }}}

" Plugins
" {{{
call plug#begin('~/.local/share/nvim/plugged')
"" Appearance
Plug 'itchyny/lightline.vim'
Plug 'itchyny/vim-gitbranch'
Plug 'ryanoasis/vim-devicons'
Plug 'maximbaz/lightline-ale'
Plug 'Yggdroot/indentLine'
"" Git
Plug 'tpope/vim-fugitive'
"" Syntax
Plug 'bfrg/vim-cpp-modern'
Plug 'dag/vim-fish'
Plug 'hdima/python-syntax'
Plug 'Shougo/neco-vim'
Plug 'mitsuhiko/vim-jinja'
Plug 'suan/vim-instant-markdown', {'for': 'markdown'}
"" Misc
Plug 'scrooloose/nerdcommenter'
Plug 'scrooloose/nerdtree'
Plug 'majutsushi/tagbar'
Plug 'lambdalisue/suda.vim'
Plug 'ludovicchabant/vim-gutentags'
Plug '907th/vim-auto-save'
Plug 'jmcantrell/vim-virtualenv'
Plug 'tpope/vim-surround'
Plug 'vim-ctrlspace/vim-ctrlspace'
"" Linting and LSP
Plug 'dense-analysis/ale'
Plug 'prabirshrestha/vim-lsp'
"" Snippets
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
"" Completion
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-file.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/asyncomplete-buffer.vim'
Plug 'prabirshrestha/asyncomplete-necovim.vim'
Plug 'prabirshrestha/asyncomplete-tags.vim'
Plug 'prabirshrestha/asyncomplete-ultisnips.vim'
"" Project-specific settings
Plug 'LucHermitte/lh-vim-lib'
Plug 'LucHermitte/local_vimrc'
call plug#end()
" }}}

" Basic configuration
" {{{
syntax on
filetype plugin indent on
set relativenumber
set mouse=a
set autochdir
set noshowmode
set clipboard+=unnamedplus
set hidden
"" Tab configuration
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab
set autoindent
set backspace=indent,eol,start
set autoindent
set copyindent
set shiftround
set breakindent
set wildmenu
set listchars=eol:¬,tab:>-,space:·,trail:~,extends:>,precedes:<
"" Search
set incsearch
set ignorecase
set smartcase
"" Fuzzy search
set path=**
set wildignore+=*/.git/*,*/node_modules/*,*/venv/*,*/__pycache__/*,*.o,*~
set wildignore+=*.pyc,*/.idea/*
"" Auto read modifications from outside
set autoread
"" Enable modelines
set modeline
"" Delete all the buffers not opened in a window or a tab
"" See: https://stackoverflow.com/a/7321131
function! DeleteInactiveBufs()
    " From tabpagebuflist() help, get a list of all buffers in all tabs
    let tablist = []
    for i in range(tabpagenr('$'))
        call extend(tablist, tabpagebuflist(i + 1))
    endfor
    let nWipeouts = 0
    for i in range(1, bufnr('$'))
        if bufexists(i) && !getbufvar(i,'&mod') && index(tablist, i) == -1
        " bufno exists AND isn't modified AND isn't in the list of buffers open
        " in windows and tabs
            silent exec 'bwipeout' i
            let nWipeouts = nWipeouts + 1
        endif
    endfor
    echomsg nWipeouts . ' buffer(s) wiped out'
endfunction
command! ClearBuffers :call DeleteInactiveBufs()
"" :W sudo saves the file
command! W w suda://%
"" Default highlight groups
highlight Whitespace ctermfg=8
highlight Folded ctermfg=0 ctermbg=6
highlight Visual ctermbg=8
highlight DiffAdd ctermbg=4 ctermfg=0
highlight Pmenu ctermbg=8 ctermfg=7
"" Views
set viewoptions=cursor,folds,slash,unix
let nosaveview=['help', 'netrw', 'vim-plug', 'gitcommit', '']
augroup AutoSaveView
    autocmd!
    autocmd BufWinLeave,BufLeave,BufWritePost ?* nested
        \ if index(nosaveview, &ft) < 0 | silent! mkview!
    autocmd BufWinEnter ?*
        \ if index(nosaveview, &ft) < 0 | silent! loadview
augroup end
"" Python
let g:python3_host_prog = '~/.config/nvim/py3nvim/bin/python3'
let g:python_host_prog = '~/.config/nvim/py2nvim/bin/python2'
" }}}

" Plugin configuration
" {{{
"" Lightline
let g:lightline = {}
let g:lightline.colorscheme = 'wombat'
let g:lightline.component_expand = {
\   'linter_checking': 'lightline#ale#checking',
\   'linter_warnings': 'lightline#ale#warnings',
\   'linter_errors': 'lightline#ale#errors',
\   'linter_ok': 'lightline#ale#ok',
\}
let g:lightline.component_type = {
\   'linter_checking': 'left',
\   'linter_warnings': 'warning',
\   'linter_errors': 'error',
\   'linter_ok': 'left',
\}
let g:lightline.component_function = {
\   'gitbranch': 'fugitive#head',
\   'virtualenv': 'virtualenv#statusline',
\}
let g:lightline.active = {
\   'left': [
\       ['mode', 'paste'],
\       ['gitbranch', 'virtualenv', 'readonly', 'filename', 'modified'],
\   ],
\   'right': [
\       ['lineinfo'],
\       ['percent'],
\       ['linter_checking', 'linter_errors', 'linter_warnings', 'linter_ok'],
\       ['fileformat', 'fileencoding', 'filetype']
\   ],
\}
"" Display vertical line for indentation levels
let g:indentLine_char = '|'
"" AutoSave
let g:auto_save = 1
let g:auto_save_silent = 1
let g:auto_save_events = ['BufLeave']
"" ALE
let g:ale_disable_lsp = 1
let g:ale_completion_enabled = 1
let g:ale_set_balloons = 1
let g:ale_linters_explicit = 1
let g:ale_fix_on_save = 1
let g:ale_linters = {
\   'cmake': ['cmakelint'],
\   'fish': ['fish'],
\   'json': ['jsonlint'],
\   'vim': ['vint'],
\   'yaml': ['yamllint'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'c': ['clang-format'],
\   'cpp': ['clang-format'],
\   'cmake': ['cmakeformat'],
\   'json': ['prettier'],
\   'sh': ['shfmt'],
\   'python': ['black', 'isort'],
\   'yaml': ['prettier'],
\}
let g:ale_sign_error = 'E>'
let g:ale_sign_warning = 'I>'
highlight ALEError cterm=NONE ctermfg=0 ctermbg=1
highlight ALEWarning cterm=undercurl
highlight ALEErrorSign ctermfg=1
highlight ALEWarningSign ctermfg=5
"" vim-lsp
let g:lsp_auto_enable = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_highlight_references_enabled = 1
let g:lsp_virtual_text_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_preview_float = 1
let g:lsp_preview_keep_focus = 1
let g:lsp_textprop_enabled = 1
let g:lsp_signs_error = {'text': 'E>'}
let g:lsp_signs_warning = {'text': 'W>'}
let g:lsp_signs_information = {'text': 'I>'}
let g:lsp_signs_hint = {'text': 'H>'}
highlight lspReference cterm=inverse
highlight link LspErrorText ALEErrorSign
highlight link LspInformationText ALEWarningSign
highlight link LspHintText ALEWarningSign
highlight link LspErrorHighlight ALEError
highlight link LspInformationHighlight ALEWarning
highlight link LspHintHighlight ALEWarning
augroup VimLsp
    if executable('clangd')
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'clangd',
        \   'cmd': {
        \       server_info->[
        \           'clangd',
        \           '--compile-commands-dir=build',
        \           '--background-index',
        \           '--all-scopes-completion',
        \           '--clang-tidy',
        \           '--completion-style=detailed',
        \           '--header-insertion=iwyu',
        \           '--header-insertion-decorators',
        \           '--suggest-missing-includes',
        \           '--pch-storage=memory',
        \       ]
        \   },
        \   'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
        \})
    endif
    if executable('pyls')
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'pyls',
        \   'cmd': {
        \       server_info->[
        \           'pyls',
        \       ]
        \   },
        \   'whitelist': ['python'],
        \   'workspace_config': {
        \       'pyls': {
        \           'plugins': {
        \               'pydocstyle': {
        \                   'enabled': v:true,
        \               },
        \           },
        \       },
        \   },
        \})
    endif
    if executable('bash-language-server')
        autocmd User lsp_setup call lsp#register_server({
        \   'name': 'bash-language-server',
        \   'cmd': {
        \       server_info->[
        \           'bash-language-server',
        \           'start',
        \       ]
        \   },
        \   'whitelist': ['sh'],
        \})
    endif
augroup END
"" Asyncomplete
augroup Asyncomplete
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ale#get_source_options({
    \   'name': 'ale',
    \   'whitelist': ['*'],
    \   'priority': 10,
    \   'completor': function('asyncomplete#sources#ale#completor')
    \}))
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \   'name': 'file',
    \   'whitelist': ['*'],
    \   'priority': 10,
    \   'completor': function('asyncomplete#sources#file#completor')
    \}))
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \   'name': 'buffer',
    \   'whitelist': ['*'],
    \   'blacklist': ['c', 'cpp', 'objc', 'objcpp', 'python'],
    \   'completor': function('asyncomplete#sources#buffer#completor'),
    \   'config': {
    \       'max_buffer_size': 5000000,
    \   },
    \}))
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#necovim#get_source_options({
    \   'name': 'necovim',
    \   'whitelist': ['vim'],
    \   'completor': function('asyncomplete#sources#necovim#completor'),
    \}))
    autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#tags#get_source_options({
    \   'name': 'tags',
    \   'whitelist': ['*'],
    \   'blacklist': ['c', 'cpp', 'objc', 'objcpp', 'python'],
    \   'completor': function('asyncomplete#sources#tags#completor'),
    \   'config': {
    \       'max_file_size': 50000000,
    \   },
    \}))
    if has('python3')
        autocmd User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ultisnips#get_source_options({
        \   'name': 'ultisnips',
        \   'whitelist': ['*'],
        \   'completor': function('asyncomplete#sources#ultisnips#completor'),
        \}))
    endif
augroup END
"" UltiSnips
let g:UltiSnipsUsePythonVersion = 3
let g:UltiSnipsExpandTrigger = '<c-e>'
"" NERDCommenter
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
"" NERDTree
""" Open files with split
let NERDTreeMapOpenSplit = 'h'
let NERDTreeMapOpenVSplit = 'v'
augroup NERDTree
    """ Start NERDTree when no file is specified
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
    """ Start NERDTree when a directory is opened
    autocmd StdinReadPre * let s:std_in=1
    autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) &&
        \ !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
augroup END
"" Local vimrc
let g:local_vimrc = ['.vimconfig', '_vimrc_local.vim']
"" Suda
let g:suda_smart_edit = 1
" }}}

" Filetype specific settings
" {{{
augroup FileSyntax
    autocmd FileType fish
    \   compiler fish
    autocmd FileType python
    \   setlocal tabstop=4       |
    \   setlocal shiftwidth=4    |
    \   setlocal textwidth=79    |
    \   setlocal fileformat=unix
    autocmd FileType json,html,css,xml
    \   setlocal tabstop=2       |
    \   setlocal shiftwidth=2
    "" Set a syntax for some extenstions
    autocmd BufReadPost *.opml setlocal syntax=xml | setlocal filetype=xml
    autocmd BufReadPost *.rasi setlocal syntax=css | setlocal filetype=css
    autocmd BufReadPost *.vue setlocal syntax=html
augroup END
let g:python_highlight_all = 1
"" Markdown
let g:instant_markdown_browser = '/usr/bin/firefox --new-tab'
"let g:instant_markdown_slow = 1
"let g:instant_markdown_autostart = 0
"let g:instant_markdown_open_to_the_world = 1
"let g:instant_markdown_allow_unsafe_content = 1
"let g:instant_markdown_allow_external_content = 0
"let g:instant_markdown_mathjax = 1
"let g:instant_markdown_logfile = '/tmp/instant_markdown.log'
"let g:instant_markdown_autoscroll = 0
"let g:instant_markdown_port = 8888
"let g:instant_markdown_python = 1
" }}}

" Keybindings
" {{{
"" Ctrl+T -> Toggles the tagbar
map <C-t> :TagbarToggle<CR>
"" Ctrl+N -> Map open/close NERDTree to Ctrl+N
map <C-n> :NERDTreeToggle<CR>
"" Ctrl+Alt+N -> Focus NERDTree window (open it if it's closed)
map <C-A-n> :NERDTreeFocus<CR>
"" Ctrl+[Left | Right] -> tabs navigation
nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
"" Ctrl+Up -> insert ':tabnew ' in the command line
nnoremap <C-Up> :tabnew <right>
"" Ctrl+Down -> close the current tab (can't close the last one)
nnoremap <C-Down> :tabclose<CR>
"" Asyncomplete
""" Tab -> next item
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
""" Shift+Tab -> Previous item
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"
""" Backslash is the real leader but space is mapped to it
" }}}

" vim:foldmethod=marker:foldlevel=0:foldenable
