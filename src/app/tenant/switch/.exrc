if &cp | set nocp | endif
let s:cpo_save=&cpo
set cpo&vim
nmap gx <Plug>NetrwBrowseX
nnoremap <silent> <Plug>NetrwBrowseX :call netrw#NetrwBrowseX(expand("<cWORD>"),0)
let &cpo=s:cpo_save
unlet s:cpo_save
set autoindent
set autoread
set background=dark
set backspace=indent,eol,start
set expandtab
set fileencodings=ucs-bom,utf-8,latin1
set guicursor=a:blinkon0
set helplang=en
set hidden
set history=1000
set hlsearch
set incsearch
set listchars=tab:\ \ ,trail:·
set ruler
set runtimepath=~/.vim,~/.vim/bundle/jedi-vim,~/.vim/bundle/vim-coffee-script,~/.vim/bundle/vim-fish,~/.vim/bundle/vim-lucius,/usr/share/vim/vimfiles,/usr/share/vim/vim74,/usr/share/vim/vimfiles/after,~/.vim/bundle/jedi-vim/after,~/.vim/bundle/vim-coffee-script/after,~/.vim/after
set scrolloff=8
set shiftwidth=2
set showcmd
set sidescroll=1
set sidescrolloff=15
set smartindent
set smarttab
set softtabstop=2
set noswapfile
set tabstop=2
set undodir=~/.vim/backups
set undofile
set viminfo='100,f1
set visualbell
set wildignore=*.o,*.obj,*~,*vim/backups*,*sass-cache*,*DS_Store*,vendor/rails/**,vendor/cache/**,*.gem,log/**,tmp/**,*.png,*.jpg,*.gif
set wildmenu
set wildmode=list:longest
set nowritebackup
" vim: set ft=vim :
