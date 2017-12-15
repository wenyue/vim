autocmd! bufwritepost G55_client.vim source %

" 配置
let s:script=g:dir.'Package/Script/Python'

" 设置path
function! SetPath()
	set path=.
	silent execute 'set path+='.s:script.'**'
endfunction
call SetPath()

" CtrlP
function! CtrlP()
	silent execute 'CtrlP '.s:script
endfunction
map <silent> <leader>f :call CtrlP() <CR>

" EasyGrep
let g:EasyGrepRoot=s:script

" 运行程序
function! Exe(program)
python << EOF
import vim
import subprocess
work_dir = vim.eval('g:dir')
program = vim.eval('a:program')
if program == 'game':
	subprocess.Popen(work_dir + 'Messiah_TXM.bat', cwd=work_dir)
EOF
endfunction
command! -nargs=1 Exe :call Exe('<args>')

" 运行游戏
map <silent> <F5> :call Exe('game') <CR>

" SVN
function! Svn(command)
	if a:command == 'up'
		" up
		silent execute '!start TortoiseProc /command:update /path:'.s:script
	elseif a:command == 'ci'
		" commit
		silent execute '!start TortoiseProc /command:commit /path:'.s:script
	elseif a:command == 'log'
		" log
		silent execute '!start TortoiseProc /command:log /path:'.s:script
	endif
endfunction
command! -nargs=1 Svn :call Svn('<args>')


