autocmd! bufwritepost G59_client.vim source %

" 配置
let s:script = g:dir.'script/'

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

" 运行程序
function! Exe(program)
python << EOF
import vim
import subprocess
program = vim.eval('a:program')
if program == 'game0':
	if os.path.exists('Documents/user.info'):
		os.remove('Documents/user.info')
		subprocess.Popen('bin/win32/client.exe')
elif program in ['game1', 'game2']:
	game_num = int(program[4])
	from win32api import GetSystemMetrics
	import win32gui, win32con, time
	s_width = GetSystemMetrics(0)
	s_height = GetSystemMetrics(1)

	# create game
	for index in range(1, game_num + 1):
		user_info = 'user%d.info' % index
		subprocess.Popen(['gamemirror.exe', '--userinfo', user_info])

	def getWindowSize(hwnd):
		rect = win32gui.GetWindowRect(hwnd)
		return rect[2] - rect[0], rect[3] - rect[1]

	# set client position
	def setClientPosition():
		while True:
			hwnd, hwnds = 0, []
			for index in range(game_num):
				hwnd = win32gui.FindWindowEx(0, hwnd, None, 'GameMirror')
				if not hwnd:
					break
				hwnds.append(hwnd)
			else:
				break
		width, height = getWindowSize(hwnd)
		positionMap = [
			(-width, (s_height-height)/2),
			(0, (s_height-height)/2),
		]

		for index, hwnd in enumerate(hwnds):
			x, y = positionMap[index]
			win32gui.SetWindowPos(hwnd, 0, x, y, 0, 0, win32con.SWP_NOSIZE | win32con.SWP_NOZORDER)
	setClientPosition()

	# set cmd position
	def setCmdPosition():
		time.sleep(3)
		hwnd, hwnds = 0, []
		for index in range(game_num):
			hwnd = win32gui.FindWindowEx(0, hwnd, None, 'Run-time Debug')
			if not hwnd:
				return
			hwnds.append(hwnd)
		width, height = getWindowSize(hwnd)
		positionMap = [
			(-s_width, 0),
			(s_width-width, 0),
		]

		for index, hwnd in enumerate(hwnds):
			x, y = positionMap[index]
			win32gui.SetWindowPos(hwnd, 0, x, y, 0, 0, win32con.SWP_NOSIZE | win32con.SWP_NOZORDER)
	setCmdPosition()

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
map <silent> <F4> :call Exe('game0') <CR>
map <silent> <F5> :call Exe('game1') <CR>
map <silent> <F6> :call Exe('game2') <CR>
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
	endif
endfunction
command! -nargs=1 Svn :call Svn('<args>')


