"autocmd! bufwritepost base.vim source %
" -------------------------------------基础配置---------------------------------
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

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
set termencoding=UTF-8
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
if g:os == 'Windows'
	function! QfMakeConv()
		let qflist = getqflist()
		for i in qflist
			let i.text = iconv(i.text, "cp936", "utf-8")
		endfor
		call setqflist(qflist)
	endfunction
	autocmd QuickFixCmdPost * call QfMakeConv()
endif

" 启动最大化
if g:os == 'Windows'
    autocmd GUIEnter * simalt ~x
else
	function! MaximizeWindow()
		silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
	endfunction
    autocmd GUIEnter * call MaximizeWindow()
endif

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

" 去除toolbar
set guioptions-=T

" 折行设置
set wrap
set showbreak=->\ 
nnoremap j gj
nnoremap k gk
nnoremap ^ g^
nnoremap $ g$


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
autocmd FileType lua,python,vim call SaveAsUTF8()

" 代码折叠
set foldmethod=indent
set foldlevel=99
nnoremap <space> za

" 快捷替换
function! ReplaceCurWord()
	let content=expand('<cword>')
	call inputsave()
	let asking='Replace "'.l:content.'" with: '
	let new_content=input(l:asking)
	call inputrestore()
	if new_content != ''
		execute '%s/\<'.l:content.'\>/'.l:new_content.'/g'
	endif
endfunction
nnoremap <silent> <leader>r :call ReplaceCurWord()<CR>

function! ReplaceCurSelection()
	let content=GetVisualSelection()
	call inputsave()
	let asking='Replace "'.l:content.'" with: '
	let new_content=input(l:asking)
	call inputrestore()
	if new_content != ''
		let content=escape(l:content, '\\/.*$^~[]')
		execute '%s/'.l:content.'/'.l:new_content.'/g'
	endif
endfunction
vnoremap <silent> <leader>r :call ReplaceCurSelection()<CR>


" -------------------------------------其它配置---------------------------------
" 显示图片
function! OpenPic(file)
	silent execute '!' a:file
	silent execute 'b #'
	silent execute 'bd #'
endfunction
autocmd bufenter *.jpg,*.png call OpenPic(expand('<afile>'))

" 打开文件所在目录
function! OpenDir(filename)
	silent execute '!start explorer /select,' a:filename
endfunction
nnoremap <silent> <leader>w :call OpenDir(expand('%')) <CR>


" -------------------------------------插件配置---------------------------------
let s:plugged_dir=expand('<sfile>:p:h:h').'/'
call plug#begin(s:plugged_dir)

" 文件查找
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
let g:ctrlp_match_window_reversed=0
let g:ctrlp_max_files=0
let g:ctrlp_max_height=20
let g:ctrlp_working_path_mode='rw'
let g:ctrlp_match_window='bottom,order:ttb,min:1,max:20,results:100'
let g:ctrlp_match_func={ 'match': 'pymatcher#PyMatch' }
let g:ctrlp_use_caching=0
let g:ctrlp_user_command='ag %s -l --nocolor -g ""'
let g:ctrlp_user_command.=' --ignore="*.pyo"'
let g:ctrlp_user_command.=' --ignore="*.pyc"'

" 全文搜索
Plug 'wenyue/vim-easygrep'
set grepprg=ag\ --nogroup\ --nocolor
let g:EasyGrepCommand=1
let g:EasyGrepRecursive=1
let g:EasyGrepIgnoreCase=0
let g:EasyGrepReplaceWindowMode=2
let g:EasyGrep=2
let g:EasyGrepJumpToMatch=0
let g:EasyGrepFilesToExclude='.svn,.git'

" 自动补全
Plug 'Valloric/YouCompleteMe', {'do': 'python install.py --msvc 14'}
set completeopt=longest,menu
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
nnoremap <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_complete_in_comments=1
let g:ycm_complete_in_strings=1
let g:ycm_seed_identifiers_with_syntax=1

" 语法检测
Plug 'w0rp/ale', {'do': 'pip install flake8'}
let g:ale_python_flake8_options="--max-complexity 10 --max-line-length 160 --ignore=W191,E101,E128"
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
Plug 'wenyue/yapf', {'do': 'python setup.py install'}
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
" 获取选中内容
function! GetVisualSelection()
    " Why is this not a built-in Vim script function?!
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

function! ToWinPath(path)
	return substitute(substitute(a:path, '/', '\', 'g'), ' ', '\\ ', 'g')
endfunction

function! ToUnixPath(path)
	return substitute(substitute(a:path, '\', '/', 'g'), ' ', '\\ ', 'g')
endfunction

function! LoadProjectConfig(project)
	silent execute 'source' s:plugged_dir.'vim/projects/'.a:project.'.vim'
endfunction

let s:workspace = findfile('workspace.vim', '.;')
if !empty(s:workspace) && !exists('g:dir')
	let g:root_path = ToUnixPath(fnamemodify(s:workspace, ":p:h").'\')
	let g:work_path = g:root_path

	" 导入配置
	silent execute 'source' s:workspace

	" 显示状态行
	set laststatus=2
	function! ShowPath()
		let filename = ToUnixPath(expand('%:p'))
		return substitute(l:filename, g:work_path, '', 'g')
	endfunction
	set statusline=%<%{ShowPath()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P

	" 设置path
	function! SetPath()
		set path=.
		silent execute 'set path+='.g:work_path.'**'
	endfunction
	call SetPath()

	" CtrlP
	function! CtrlP()
		silent execute 'CtrlP '.g:work_path
	endfunction
	map <silent> <leader>f :call CtrlP() <CR>

	" EasyGrep
	let g:EasyGrepRoot=g:work_path

endif

