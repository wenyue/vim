autocmd! bufwritepost G55_client.vim source %

let g:work_path=g:root_path.'Python'

" 配置虚拟环境
let g:ycm_python_binary_path = g:dir.'python/Scripts/python.exe'

" 运行程序
function! Exe(program)
python << EOF
import vim
import subprocess
work_dir = vim.eval('g:root_path')
program = vim.eval('a:program')
root_dir = work_dir + '../../'
if program == 'game':
	subprocess.Popen(root_dir + 'Messiah_TXM.bat', cwd=root_dir)
EOF
endfunction
command! -nargs=1 Exe :call Exe('<args>')

" 运行游戏
map <silent> <F5> :call Exe('game') <CR>

" SVN
function! Svn(command)
	if a:command == 'up'
		" up
		silent execute '!start TortoiseProc /command:update /path:'.g:work_path
	elseif a:command == 'ci'
		" commit
		silent execute '!start TortoiseProc /command:commit /path:'.g:work_path
	elseif a:command == 'log'
		" log
		silent execute '!start TortoiseProc /command:log /path:'.g:work_path
	endif
endfunction
command! -nargs=1 Svn :call Svn('<args>')


