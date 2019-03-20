autocmd! bufwritepost % source %

" esay
let g:EasyGrepFilesToExclude .= ',common/experimental,make8-bin,bazel*'

" ctrlp
let g:ctrlp_user_command .= ' --ignore-dir="make8-bin" --ignore-dir="bazel*"'


" tab相关
set tabstop=2
set softtabstop=2
set shiftwidth=2
