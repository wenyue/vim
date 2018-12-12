autocmd! bufwritepost % source %

" esay设置
let g:EasyGrepFilesToExclude .= 'common/experimental,make8-bin,bazel*'

" tab相关设置
set tabstop=2
set softtabstop=2
set shiftwidth=2

" ycm设置
let g:ycm_global_ycm_extra_conf = expand('<sfile>:p:h').'/ponyai_ycm_conf.py'

" ale设置
let g:ale_c_clang_executable = 'clang'
function! InitClangOptions()
python << EOF
import vim
import imp
ycm_conf_path = vim.eval('g:ycm_global_ycm_extra_conf')
ycm_conf = imp.load_source('ycm_conf', ycm_conf_path)
flags = ' '.join(ycm_conf.MakeRelativePathsInFlagsAbsolute(ycm_conf.flags))
external_cmd = "-ferror-limit=30"
vim.command("let g:ale_cpp_clang_options = '%s %s'" % (flags, external_cmd))
vim.command("let g:ale_c_clang_options = '%s %s'" % (flags, external_cmd))
EOF
endfunction
call InitClangOptions()
