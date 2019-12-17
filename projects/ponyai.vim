autocmd! BufWritePost % source %

" tab相关
set tabstop=2
set softtabstop=2
set shiftwidth=2

" esay
let g:EasyGrepFilesToExclude .= ',common/experimental,make8-bin,bazel*'

" autoformat
let g:formatdef_clangformat = "'/usr/bin/clang-format-6.0 -lines='.a:firstline.':'.a:lastline.' --assume-filename=\"'.expand('%:p').'\" -style=\"{BasedOnStyle: Google, BinPackArguments: false, BinPackParameters: false, ColumnLimit: 100, DerivePointerAlignment: false, PointerAlignment: Left, SortUsingDeclarations: true}\"'"

" ctrlp
let g:ctrlp_user_command .= ' --ignore-dir="make8-bin" --ignore-dir="bazel*"'

" bazel
function! RegenerateCompileDatabase()
  silent execute ':AsyncRun! -post=YcmRestartServer cd '.g:work_path.' && ./common/third_party/bazel-compilation-database/generate.sh'
endfunction
map <silent> <F9> :call RegenerateCompileDatabase()<CR>

function! FormatBuildFile()
  silent execute ':! buildifier %'
  if v:shell_error
    return
  endif
  silent execute ':edit'
  call RegenerateCompileDatabase()
endfunction
autocmd BufWritePost BUILD call FormatBuildFile()

" 设置环境变量
let $PONYAI_PATH = g:root_path
