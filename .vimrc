syntax enable

set autoindent
set smartindent

set number
set encoding=utf-8

set ignorecase
set hlsearch
set incsearch

nnoremap <esc><esc> :noh<return>

set clipboard=unnamedplus

autocmd FileType html,css,ruby,javascript,java,dart,kotlin setlocal ts=2 sts=2 sw=2 expandtab
autocmd FileType python,bash,sh setlocal ts=4 sts=4 sw=4 expandtab
autocmd FileType make setlocal noexpandtab
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

autocmd FileType ruby,javascript,java,python,bash,sh,html,css,yaml,make autocmd BufWritePre * %s/\s\+$//e
