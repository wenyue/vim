autocmd! bufwritepost *.vim source %


" -------------------------------------公用配置---------------------------------
if !exists("g:os")
    if has("win64") || has("win32") || has("win16")
        let g:os = "Windows"
        behave mswin
    else
        let g:os = substitute(system('uname'), '\n', '', '')
    endif
endif

function! ToWinPath(path)
    return substitute(a:path, '/', '\', 'g')
endfunction

function! ToUnixPath(path)
    return substitute(a:path, '\', '/', 'g')
endfunction

function! ToSetPath(path)
    return substitute(a:path, ' ', '\\ ', 'g')
endfunction

let g:root_path = ToUnixPath(expand('%:p:h'))
let g:work_path = g:root_path


" -------------------------------------基础配置---------------------------------
" 不兼容vi
set nocompatible

" 自动读取变更
set autoread

" 配置leader键
let mapleader = ','

" 忽略大小写
set ignorecase
set smartcase

" 搜索配置
set hlsearch
set incsearch
nn <silent> <C-n> :nohl<CR>

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

" 编码设置
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
    autocmd QuickfixCmdPost grep call QfMakeConv()
endif
function! SaveAsUTF8()
    set fileencoding=UTF-8
    set nobomb
endfunction
autocmd FileType lua,python,vim call SaveAsUTF8()

" 设置补全顺序
set cpt=.,w,b

" 不要发出bell声音
set vb

" Window快捷键
nn <Left> <C-w>h
nn <Down> <C-w>j
nn <Up> <C-w>k
nn <Right> <C-w>l

" 折行移动
nn j gj
nn k gk
nn ^ g^
nn $ g$

" 标签快捷键
if g:os == 'Windows'
    nn <M-1> 1gt
    nn <M-2> 2gt
    nn <M-3> 3gt
    nn <M-4> 4gt
    nn <M-5> 5gt
    nn <M-6> 6gt
    nn <M-7> 7gt
    nn <M-8> 8gt
    nn <M-9> 9gt
    nn <silent> <M-n> :tabnext<CR>
    nn <silent> <M-p> :tabprevious<CR>
    nn <silent> <M-e> :tabedit %<CR>
    nn <silent> <M-q> :tabclose<CR>
endif

" 设置path
function! SetPath()
    set path=.
    silent execute 'set path+='.ToSetPath(g:work_path.'\**')
endfunction
call SetPath()


" -------------------------------------界面配置---------------------------------
" 显示行号
set number

" 显示当前位置
set ruler

" 上下文行数
set so=5

" 去除toolbar
set guioptions-=T
set guioptions-=m

" 启动最大化
if g:os == 'Windows'
    autocmd GUIEnter * simalt ~x
else
    function! MaximizeWindow()
        silent !wmctrl -r :ACTIVE: -b add,maximized_vert,maximized_horz
    endfunction
    autocmd GUIEnter * call MaximizeWindow()
endif

" 折行设置
set wrap
set showbreak=->\

" 代码折叠
set foldmethod=indent
set foldlevel=99
nn <space> za

" 标签名字
function! NeatBuffer(bufnr, fullname)
    let l:name = bufname(a:bufnr)
    if getbufvar(a:bufnr, '&modifiable')
        if l:name == ''
            return '[No Name]'
        else
            if a:fullname
                return fnamemodify(l:name, ':p')
            else
                return fnamemodify(l:name, ':t')
            endif
        endif
    else
        let l:buftype = getbufvar(a:bufnr, '&buftype')
        if l:buftype == 'quickfix'
            return '[Quickfix]'
        elseif l:name != ''
            if a:fullname
                return '-'.fnamemodify(l:name, ':p')
            else
                return '-'.fnamemodify(l:name, ':t')
            endif
        else
        endif
        return '[No Name]'
    endif
endfunc

function! NeatGuiTabLabel()
    let l:num = v:lnum
    let l:buflist = tabpagebuflist(l:num)
    let l:winnr = tabpagewinnr(l:num)
    let l:bufnr = l:buflist[l:winnr - 1]
    return l:num.': '.NeatBuffer(l:bufnr, 0)
endfunc

set guitablabel=%{NeatGuiTabLabel()}

" 显示状态行
set laststatus=2
function! ShowPath()
    let filename = ToUnixPath(expand('%:p'))
    return substitute(l:filename, g:work_path.'/', '', 'g')
endfunction
set statusline=%<%{ShowPath()}\ %h%m%r%=%-14.(%l,%c%V%)\ %P


" -------------------------------------编辑配置---------------------------------
" 退格键
set backspace=indent,eol,start whichwrap+=<,>,[,]

" tab长度
set tabstop=4
set softtabstop=4
set expandtab
set smarttab
set autoindent
let g:python_recommended_style = 0

" 换行
set shiftwidth=4
set shiftround

" 快捷替换
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

function! ReplaceCurWord()
    let content = expand('<cword>')
    call inputsave()
    let new_content = input("Replace '".l:content."' with: ", l:content)
    call inputrestore()
    if new_content !=# content && new_content != ''
        execute '%s/\<'.l:content.'\>/'.l:new_content.'/g|norm!``'
    endif
endfunction
nn <leader>r :call ReplaceCurWord()<CR>

function! ReplaceCurSelection()
    let content = GetVisualSelection()
    call inputsave()
    let new_content = input("Replace '".l:content."' with: ", l:content)
    call inputrestore()
    if new_content !=# content && new_content != ''
        let content = escape(l:content, '\\/.*$^~[]')
        execute '%s/'.l:content.'/'.l:new_content.'/g|norm!``'
    endif
endfunction
vn <leader>r :call ReplaceCurSelection()<CR>


" -------------------------------------其它配置---------------------------------
" 显示图片
if g:os == 'Windows'
    function! OpenPic(file)
        silent execute '!' a:file
        silent execute 'b #'
        silent execute 'bd #'
    endfunction
    autocmd bufenter *.jpg,*.png silent call OpenPic(expand('<afile>'))
endif

" 打开文件所在目录
if g:os == 'Windows'
    function! OpenDir(filename)
        silent execute '!start explorer /select,' a:filename
    endfunction
    nn <silent> <leader>w :call OpenDir(expand('%')) <CR>
endif


" -------------------------------------插件配置---------------------------------
filetype plugin indent on

let s:base_path = ToUnixPath(expand('<sfile>:p:h'))
let s:plugged_path = ToUnixPath(expand('<sfile>:p:h:h').'/plugged')

" 添加tools目录
if !exists('s:tools_path')
    let s:tools_path = s:base_path.'/tools'
    let $PATH .= ';'.s:tools_path
endif

" 头文件切换
execute 'source' s:base_path.'/scripts/fswitch.vim'
map <silent> <leader>a :FSHere<CR>

" 开始加载plugs
execute 'source' s:base_path.'/scripts/plug.vim'
call plug#begin(s:plugged_path)

" 文件查找
Plug 'kien/ctrlp.vim'
Plug 'FelikZ/ctrlp-py-matcher'
let g:ctrlp_match_window_reversed  =  0
let g:ctrlp_max_files = 0
let g:ctrlp_max_height = 20
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:20,results:100'
let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
let g:ctrlp_use_caching = 0
if g:os == 'Windows'
    let g:ctrlp_user_command = 'ag -i "%s" -l --nocolor -f -g ""'
else
    let g:ctrlp_user_command = 'ag -i %s -l --nocolor -f -g ""'
endif
let g:ctrlp_user_command .= ' --ignore="*.pyo"'
let g:ctrlp_user_command .= ' --ignore="*.pyc"'
let g:ctrlp_prompt_mappings = {
            \ 'AcceptSelection("e")': [],
            \ 'AcceptSelection("r")': ['<cr>', '<2-LeftMouse>'],
            \ }
function! CtrlP()
    silent execute 'CtrlP' g:work_path
endfunction
map <silent> <leader>f :call CtrlP() <CR>

" 全文搜索
Plug 'wenyue/vim-easygrep'
set grepprg=ag\ --nogroup\ --nocolor\ -f
let g:EasyGrepCommand = 1
let g:EasyGrepRecursive = 1
let g:EasyGrepIgnoreCase = 0
let g:EasyGrepReplaceWindowMode = 2
let g:EasyGrep = 2
let g:EasyGrepJumpToMatch = 0
let g:EasyGrepFilesToExclude = '.svn,.git'

" 自动补全
if g:os == 'Windows'
    Plug 'Valloric/YouCompleteMe', {'do': 'python install.py --msvc 14'}
else
    Plug 'Valloric/YouCompleteMe', {'do': 'python install.py --clang-completer'}
endif
set completeopt=menuone,preview
autocmd InsertLeave * if pumvisible() == 0|pclose|endif
nn <leader>d :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_seed_identifiers_with_syntax = 1

" 格式整理
Plug 'Chiel92/vim-autoformat'
map <silent> <leader>s :Autoformat<CR>

" 语法检测
Plug 'w0rp/ale', {'do': 'pip install flake8'}
let g:ale_linters = {
            \   'python': ['flake8'],
            \   'c': ['clang'],
            \   'cpp': ['clang'],
            \}

" 快速注释
Plug 'scrooloose/nerdcommenter'
let g:NERDDefaultAlign = 'left'
let g:NERDCreateDefaultMappings = 0
let g:NERDCommentEmptyLines = 1
let g:NERDSpaceDelims = 1
map <silent> <leader>c <plug>NERDCommenterToggle

" 主题
Plug 'altercation/vim-colors-solarized'
Plug 'morhetz/gruvbox'

" 结束加载plugs
call plug#end()

" 加载之后选择主题
syntax enable
try
    set background=dark
    colorscheme gruvbox
catch /^Vim\%((\a\+)\)\=:E185/
    echo 'No such color scheme'
endtry

" -------------------------------------项目配置---------------------------------
function! LoadProjectConfig(project)
    execute 'source' s:base_path.'/projects/'.a:project.'.vim'
endfunction

let s:workspace = findfile('workspace.vim', '.;')
if !empty(s:workspace)
    let g:root_path = ToUnixPath(fnamemodify(s:workspace, ":p:h"))
    let g:work_path = g:root_path

    " 导入公共项目配置
    call LoadProjectConfig('common')
    " 导入项目配置
    execute 'source' s:workspace
endif
