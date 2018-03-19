autocmd! bufwritepost G55_client.vim source %

" 配置工作目录
let g:work_path = g:root_path.'Python/'

" 配置虚拟环境
let g:ycm_python_binary_path = g:root_path.'VimPython/Scripts/python.exe'

" 专用flake8配置
let g:ale_python_flake8_options .= ' --format=flake8_gta'

" 运行程序
function! Exe(program)
python << EOF
import vim
import subprocess
root_path = vim.eval('g:root_path') + '../../'
program = vim.eval('a:program')
if program == 'game':
	subprocess.Popen(root_path + 'Messiah_Run.bat', cwd=root_path)
EOF
endfunction
command! -nargs=1 Exe :call Exe('<args>')

" 运行游戏
map <silent> <F5> :call Exe('game') <CR>
