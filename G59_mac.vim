autocmd! bufwritepost G59_mac.vim source %

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


