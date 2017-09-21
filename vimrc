set clipboard=unnamed

set tabstop=2
set softtabstop=2
set shiftwidth=2
set expandtab
filetype on
filetype plugin on
filetype indent on
syntax on
" colorscheme predawn
set smartindent
set autoindent
set nowrap
set hlsearch
set number
highlight LineNr ctermfg=darkgrey
set showmatch

set laststatus=2
let g:airline_powerline_fonts = 1

" delete all trailing space
autocmd BufWritePre * :%s/\s\+$//e

set mouse=a " enables the mouse
set history=1000 " more undo'ing
set lcs=tab:▸\ ,trail:·,eol:¬,nbsp:_ " show specific invisible characters
set incsearch " incrementally search/highlight as you're typing
set scrolloff=5 " start scrolling when the cursor is five lines away from the edge of screen
set cursorline " highlight the entire line that your cursor is on
" hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
" hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=darkred guifg=white
highlight CursorLine cterm=NONE ctermbg=darkgray

let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

