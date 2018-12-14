autocmd! bufwritepost % source %

" 设置ctags
silent execute 'set tags='.ToPathString(g:root_path.'/tags')

" esay设置
let g:EasyGrepFilesToExclude .= 'common/experimental,make8-bin,bazel*'

" tab相关设置
set tabstop=2
set softtabstop=2
set shiftwidth=2

" ycm设置
let g:ycm_global_ycm_extra_conf = expand('<sfile>:p:h').'/ponyai_ycm_conf.py'

set omnifunc=syntaxcomplete#Complete

