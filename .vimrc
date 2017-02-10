"set autoindent

" expand tabs into spaces
set expandtab

" set the number of spaces in a tab (visual)
set tabstop=4

" set the number of spaces in a tab (when editing)
set softtabstop=4

set ruler

" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4

set shiftround

" enable syntax highlighting
syntax on

" turn on invisible characters
set list listchars=tab:▷⋅,trail:⋅,nbsp:⋅

" configure status line
set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\
    \ [%l/%L\ (%p%%)

" turn on selective indentation
filetype plugin indent on
au FileType py set autoindent
au FileType py set smartindent
au FileType py set textwidth=79 " PEP-8 Friendly

" show line numbers
set number

" show command in bottom bar
set showcmd

" show a visual line under the cursor's current line 
set cursorline

" visual autocomplete for command menu
set wildmenu

" show the matching part of the pair for [] {} and ()
set showmatch

" enable all Python syntax highlighting features
let python_highlight_all = 1

" search as characters are entered
set incsearch

" highlight search matches
set hlsearch

" set split and vsplit to open new buffers below and right
set splitbelow
set splitright

" choose the colorscheme
"colorscheme molokai
"let g:molokai_original = 1
"let g:rehash256 = 1
"syntax enable
"set background=dark
"colorscheme solarized
"let g:solarized_termcolors=256
colorscheme badwolf

" disable autoindent when pasting text
set paste

execute pathogen#infect()

" Syntastic options
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

" Better :sign interface symbols
let g:syntastic_error_symbol = '✗'
let g:syntastic_warning_symbol = '!'

" Use flake8
let g:syntastic_python_checkers = ['pyflakes', 'flake8', 'pylint']

