" -------------------------------------基础配置---------------------------------
autocmd! bufwritepost vimrc source %

" 自动读取变更
set autoread

" 忽略大小写
set ignorecase
set smartcase

" 使用鼠标
set mouse=a

" 自动更改工作目录
set autochdir

" 取消备份
set nobackup
set noswapfile

" 隐藏缓冲区
set hidden

" 内部编码
set encoding=UTF-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim

" 设置<leader>
let mapleader=','

" 设置补全顺序
set cpt=.,w,b

" 不要发出bell声音
set vb 


" -------------------------------------界面配置---------------------------------
" 显示行号
set number

" 显示当前位置
set ruler

" 搜索高亮
set hlsearch

" 上下文行数
set so=5


" -------------------------------------编辑配置---------------------------------
" 智能tab
set smarttab

" 智能缩进
set autoindent

" tab长度
set tabstop=4
set softtabstop=4
set noexpandtab

" 换行
set shiftwidth=4
set shiftround

" 使用utf-8编码
function! SaveAsUTF8()
	set fileencoding=UTF-8
	set nobomb
endfunction
autocmd FileType lua,python :call :SaveAsUTF8()


" -------------------------------------插件配置---------------------------------
call plug#begin('$VIM/vimfiles/plugged')

Plug 'wenyue/vim'
" 文件查找
Plug 'kien/ctrlp.vim' | Plug 'adonis0147/ctrlp-cIndexer'
Plug 'FelikZ/ctrlp-py-matcher'
" 自动补全
"Plug 'Valloric/YouCompleteMe', {'do': 'python install.py'}
" 语法检测
Plug 'kevinw/pyflakes-vim', {'for': 'python'}
" 主题
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
"nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR> " 跳转到定义处
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


" -------------------------------------项目配置---------------------------------
" 显示图片
function! s:OpenPic(file)
	silent execute '!' a:file
	silent execute 'b #'
	silent execute 'bd #'
endfunction
autocmd! bufenter *.jpg,*.png :call s:OpenPic(expand('<afile>'))

" 打开文件所在目录
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

	" 显示状态行
	set laststatus=2
	function! ShowPath()
		let filename = ToUnixPath(expand('%:p'))
		return substitute(l:filename, g:dir, '', 'g')
	endfunction
	set statusline=%<%{ShowPath()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

	" 读取项目配置
	execute 'source '.s:workspace
endif

