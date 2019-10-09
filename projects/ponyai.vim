autocmd! bufwritepost % source %

" esay
let g:EasyGrepFilesToExclude .= ',common/experimental,make8-bin,bazel*'

" ctrlp
let g:ctrlp_user_command .= ' --ignore-dir="make8-bin" --ignore-dir="bazel*"'

" ycm
let g:ycm_global_ycm_extra_conf = expand('<sfile>:p:h').'/ponyai-bazel-compilation-database/ycm_extra_conf.py'

" tab相关
set tabstop=2
set softtabstop=2
set shiftwidth=2
