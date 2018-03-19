autocmd! bufwritepost common.vim source %

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
