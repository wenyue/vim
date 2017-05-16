autocmd! bufwritepost base.vim source %
" -------------------------------------基础配置---------------------------------
" 不兼容vi
set nocompatible

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
set noundofile

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
filetype plugin indent on 

" tab长度
set tabstop=4
set softtabstop=4
set smarttab
set noexpandtab
set autoindent
let g:python_recommended_style=0

" 换行
set shiftwidth=4
set shiftround

" 使用utf-8编码
function! SaveAsUTF8()
	set fileencoding=UTF-8
	set nobomb
endfunction
autocmd FileType lua,python,vim :call SaveAsUTF8()

" 代码折叠
set foldmethod=indent
set foldlevel=99
nnoremap <space> za


" -------------------------------------插件配置---------------------------------
let s:plugged_dir=expand('<sfile>:p:h:h').'/'
call plug#begin(s:plugged_dir)
Plug 'wenyue/vim'

" 文件查找
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
let g:ctrlp_match_window_reversed=0
let g:ctrlp_max_files=0
let g:ctrlp_max_height=20
let g:ctrlp_working_path_mode='rw'
let g:ctrlp_match_window='bottom,order:ttb,min:1,max:20,results:100'
let g:ctrlp_match_func={ 'match': 'pymatcher#PyMatch' }
let g:ctrlp_clear_cache_on_exit = 1

" 全文搜索
Plug 'dkprice/vim-easygrep'
let g:EasyGrepCommand='ag'
let g:EasyGrepInvertWholeWord=1
let g:EasyGrepRecursive=1
let g:EasyGrepIgnoreCase=0
let g:EasyGrepReplaceWindowMode=2

" 自动补全
Plug 'Valloric/YouCompleteMe', {'do': 'python install.py'}
set completeopt=longest,menu
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_complete_in_comments=1
let g:ycm_complete_in_strings=1
let g:ycm_seed_identifiers_with_syntax=1

" 语法检测
Plug 'w0rp/ale', {'do': 'pip install flake8'}
let g:ale_python_flake8_options='--select F,E999'
let g:ale_linters={
\	'python': ['flake8'],
\}

" 快速注释
Plug 'scrooloose/nerdcommenter'
let g:NERDDefaultAlign='left'
let g:NERDCreateDefaultMappings=0
let g:NERDCommentEmptyLines=1
map <silent> <leader>c <plug>NERDCommenterToggle

" 主题
Plug 'tomasr/molokai'
let s:molokai_path=s:plugged_dir.'molokai/colors/molokai.vim'
if filereadable(s:molokai_path) && (!exists('g:colors_name') || g:colors_name!="molokai")
	syntax enable
	syntax on
	let g:rehash256=1
	set t_Co=256
	execute 'source' s:molokai_path
endif

" 格式整理
Plug 'google/yapf', {'do': 'python setup.py install'}
function! Yapf() range
	" Determine range to format.
	let l:line_ranges = a:firstline . '-' . a:lastline
	let l:cmd = 'yapf --lines=' . l:line_ranges . ' --style="' . s:plugged_dir . 'vim/wenyue_style.yapf"'

	" Call YAPF with the current buffer
	let l:formatted_text = system(l:cmd, join(getline(1, '$'), "\n") . "\n")

	" Update the buffer.
	execute '1,' . string(line('$')) . 'delete'
	call setline(1, split(l:formatted_text, "\n"))

	" Reset cursor to first line of the formatted range.
	call cursor(a:firstline, 1)
endfunction
command! -range=% Yapf <line1>,<line2>call Yapf()
autocmd FileType python map <silent> <leader>s :call Yapf()<CR>

call plug#end()


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

" 读取项目配置
function! LoadProjectConfig(project)
	silent execute 'source' s:plugged_dir.'vim/projects/'.a:project.'.vim'
endfunction

let s:workspace = findfile('workspace.vim', '.;')
if !empty(s:workspace) && !exists('g:dir')
	let g:dir = ToUnixPath(fnamemodify(s:workspace, ":p:h").'\')

	" 显示状态行
	set laststatus=2
	function! ShowPath()
		let filename = ToUnixPath(expand('%:p'))
		return substitute(l:filename, g:dir, '', 'g')
	endfunction
	set statusline=%<%{ShowPath()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

	silent execute 'source' s:workspace
endif

