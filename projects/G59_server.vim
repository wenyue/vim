autocmd! bufwritepost G59_server.vim source %

" 配置
let s:script = g:dir."logic/"

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
function! Exe(pragram)
	if a:pragram == "game"
		execute "!start /b start /D" ToWinPath(g:dir)."shell" "start.bat"
	endif
endfunction
command! -nargs=1 Exe :call Exe("<args>")

" 运行游戏
map <silent> <F5> :call Exe("game") <CR>

" SVN
function! Svn(command)
	if a:command == "up"
		" up
		silent execute "!start TortoiseProc /command:update /path:".g:dir
	elseif a:command == "ci"
		" commit
		silent execute "!start TortoiseProc /command:commit /path:".g:dir
	endif
endfunction
command! -nargs=1 Svn :call Svn("<args>")



