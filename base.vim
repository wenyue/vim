" -------------------------------------��������---------------------------------
autocmd! bufwritepost vimrc source %

" �Զ���ȡ���
set autoread

" ���Դ�Сд
set ignorecase
set smartcase

" ʹ�����
set mouse=a

" �Զ����Ĺ���Ŀ¼
set autochdir

" ȡ������
set nobackup
set noswapfile

" ���ػ�����
set hidden

" �ڲ�����
set encoding=UTF-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" ����<leader>
let mapleader=','

" ���ò�ȫ˳��
set cpt=.,w,b

" ��Ҫ����bell����
set vb 


" -------------------------------------��������---------------------------------
" ��ʾ�к�
set number

" ��ʾ��ǰλ��
set ruler

" ��������
set hlsearch

" ����������
set so=5


" -------------------------------------�༭����---------------------------------
" ����tab
set smarttab

" ��������
set autoindent

" tab����
set tabstop=4
set softtabstop=4
set noexpandtab

" ����
set shiftwidth=4
set shiftround

" ʹ��utf-8����
function! SaveAsUTF8()
	set fileencoding=UTF-8
	set nobomb
endfunction
autocmd FileType lua,python :call :SaveAsUTF8()


" -------------------------------------�������---------------------------------
call plug#begin('$VIM/vimfiles/plugged')

Plug 'wenyue/vim'
" �ļ�����
Plug 'kien/ctrlp.vim' | Plug 'adonis0147/ctrlp-cIndexer'
Plug 'FelikZ/ctrlp-py-matcher'
" �Զ���ȫ
"Plug 'Valloric/YouCompleteMe', {'do': 'python install.py'}
" �﷨���
Plug 'kevinw/pyflakes-vim', {'for': 'python'}
" ����
Plug 'tomasr/molokai'

call plug#end()

" ctrlp settings
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_max_files = 0
let g:ctrlp_max_height = 20
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:20,results:100'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }

" YouCompleteMe settings
"set completeopt=longest,menu
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR> " ��ת�����崦
"let g:ycm_complete_in_comments = 1
"let g:ycm_complete_in_strings = 1
"let g:ycm_seed_identifiers_with_syntax = 1

" pyflakes settings
let g:pyflakes_use_quickfix = 0

" molokai settings
let g:rehash256 = 1
set background=dark
set t_Co=256
execute 'source $VIM/vimfiles/plugged/molokai/colors/molokai.vim'


" -------------------------------------��Ŀ����---------------------------------
" ��ʾͼƬ
function! s:OpenPic(file)
	silent execute '!' a:file
	silent execute 'b #'
	silent execute 'bd #'
endfunction
autocmd! bufenter *.jpg,*.png :call s:OpenPic(expand('<afile>'))

" ���ļ�����Ŀ¼
function! OpenDir(filename)
	silent execute '!start explorer /select,' a:filename
endfunction
nnoremap <silent> <leader>r :call OpenDir(expand('%')) <CR>

function! ToWinPath(path)
	return substitute(substitute(a:path, '/', '\', 'g'), ' ', '\\ ', 'g')
endfunction

function! ToUnixPath(path)
	return substitute(substitute(a:path, '\', '/', 'g'), ' ', '\\ ', 'g')
endfunction

let s:workspace = findfile('workspace.vim', '.;')
if !empty(s:workspace)
	let g:dir = ToUnixPath(fnamemodify(s:workspace, ":p:h").'\')

	" ��ʾ״̬��
	set laststatus=2
	function! ShowPath()
		let filename = ToUnixPath(expand('%:p'))
		return substitute(l:filename, g:dir, '', 'g')
	endfunction
	set statusline=%<%{ShowPath()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

	" ��ȡ��Ŀ����
	execute 'source '.s:workspace
endif

