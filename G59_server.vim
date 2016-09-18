autocmd! bufwritepost G59_server.vim source %

" ����
let s:script = g:dir."logic/"

" ����path
function! SetPath()
	set path=.
	execute "set path+=".s:script.'**'
endfunction
call SetPath()

" ��������
function! FullSearch(content)
	let l:cmd = "vimgrep /\\C".a:content."/j ".s:script."**"
	execute l:cmd | copen
endfunction
command! -nargs=1 FullSearch :call FullSearch("<args>")

" ��������
function! Search(content)
	let l:cmd = "vimgrep /\\C".a:content."/j ".s:script."**/*.py"
	execute l:cmd | copen
endfunction
command! -nargs=1 Search :call Search("<args>")
map <silent> <leader>s :call Search(expand("<cword>")) <CR>

" CtrlP
function! CtrlP()
	execute "CtrlP ".s:script
endfunction
map <silent> <leader>f :call CtrlP() <CR>

" ���г���
function! Exe(pragram)
	if a:pragram == "game"
		execute "!start /b start /D" g:w_dir."shell" "start.bat"
	endif
endfunction
command! -nargs=1 Exe :call Exe("<args>")

" ������Ϸ
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



