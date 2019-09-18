" -------------------------
" Manual settings.
" -------------------------

" Adding undo options
if version >= 700
        set history=64
        set undolevels=128
        set undodir=~/.vim/undodir/
        set undofile
        set undolevels=1000
        set undoreload=10000
endif

" Chmod +x if file has sheebang
function ModeChange()
        if getline(1) =~ "^#!"
                if getline(1) =~ "bin/"
                        silent !chmod a+x <afile>
                endif
        endif
endfunction
au BufWritePost * call ModeChange()

" Adding sheebang if file extention is .sh
function! WriteBash()
        let @q = "
        \#\!/bin/bash\n"
        execute "0put q"
endfunction
autocmd BufNewFile *.sh call WriteBash()

" Comment and Uncomment
nnoremap  <C-c> :call CommentLine()<cr>
nnoremap  <C-u> :call UnCommentLine()<cr>
vmap  <C-c> :call CommentLine()<cr>
vmap  <C-u> :call UnCommentLine()<cr>

function __is_django_template()
        let l:a = getpos(".")
        if search("{\%.*\%}", '', line("$")) != 0
                let b:b = cursor(l:a[1], l:a[2], "off")
                return 1
        endif
        return 0
endfunction

function RetFileType()
        let file_name = buffer_name("%")
        if file_name =~ '\.vim'
                return ["\"", ""]
        elseif file_name =~ 'vimrc$'
                return ["\"", ""]
        elseif __is_django_template() == 1
                return ['{% comment %}' , '{% endcomment %}']
        elseif file_name =~ '\.html$' || file_name =~ '\.xhtml$' || file_name =~ '\.xml'
                return ["<!--", "-->"]
        endif
        return ["#", ""]
endfunction
au BufEnter * let b:comment = RetFileType()

function! CommentLine()
        let stsymbol = b:comment[0]
        let endsymbol = b:comment[1]
        execute ":silent! normal 0i" . stsymbol . "\<ESC>A" . endsymbol . "\<ESC>"
endfunction
function! UnCommentLine()
        let file_name = buffer_name("%")
        let stsymbol = b:comment[0]
        let endsymbol = b:comment[0]
        execute ":silent! normal :s/^\s*" . stsymbol . "//\<CR>"
        execute ":silent! normal :s/\s*" . endsymbol . "\s*$//\<CR>"
endfunction

"set bg=dark
"syntax on
autocmd FileType yaml setlocal ai ts=2 sw=2 et
