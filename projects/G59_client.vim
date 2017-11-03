autocmd! bufwritepost G59_client.vim source %

" 配置
let s:script=g:dir.'script/'

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
	subprocess.Popen(work_dir + 'gamemirror.exe', cwd=work_dir)
elif program == 'model':
	subprocess.Popen(['start', '/B', 'lib/modeleditor.exe.lnk'], shell=True)
elif program == 'scene':
	subprocess.Popen(['start', '/B', 'lib/sceneeditor.exe.lnk'], shell=True)
elif program == 'fx':
	subprocess.Popen(['start', '/B', 'lib/FxEdit.exe.lnk'], shell=True)
elif program == 'help':
		subprocess.Popen(['start', '/B', 'lib/NeoX-Python-API.chm.lnk'], shell=True)
EOF
endfunction
command! -nargs=1 Exe :call Exe('<args>')

" 运行游戏
map <silent> <F4> :call Exe('game') <CR>
map <silent> <F9> :call Exe('model') <CR>
map <silent> <F10> :call Exe('scene') <CR>
map <silent> <F11> :call Exe('fx') <CR>
map <silent> <F12> :call Exe('help') <CR>

" SVN
function! Svn(command)
	if a:command == 'up'
		" up
		silent execute '!start TortoiseProc /command:update /path:'.g:dir
	elseif a:command == 'ci'
		" commit
		silent execute '!start TortoiseProc /command:commit /path:'.s:script
	elseif a:command == 'log'
		" commit
		silent execute '!start TortoiseProc /command:log /path:'.expand('%')
	endif
endfunction
command! -nargs=1 Svn :call Svn('<args>')


