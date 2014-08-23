set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'ctrlp.vim'
Plugin 'syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-commentary'
call vundle#end()

"Change syntax error highlight color
hi clear SpellBad
hi SpellBad cterm=underline,bold ctermfg=white ctermbg=red

"Enable syntax higlighting
syntax enable

"Show tabs/newlines
set list

set tabstop=4
set shiftwidth=4
set nu
set hlsearch
set ai

"Convenient aliases
cabbrev Tabn tabn
cabbrev Tabp tabp
cabbrev Tabe tabe

"Refresh screen to clear garbled text
map <F5> :redraw!<CR>

"In normal mode select the just pasted text using this
nnoremap gp `[v`]

" Add switch to last tab shotcut
let g:lasttab = 1
nmap <Leader>tl :exe "tabn ".g:lasttab<CR>
au TabLeave * let g:lasttab = tabpagenr()

" Add the current file's directory to the path if not already present.
autocmd BufRead *
      \ let s:tempPath=escape(escape(expand("%:p:h"), ' '), '\ ') |
      \ exec "set path+=".s:tempPath

"Remove trailing whitespaces on save
autocmd BufWritePre *.js :%s/\s\+$//e

"let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_custom_ignore = {
\	'dir': 'bower_components$\|node_modules$\|dist$'
\}


"CtrlP config: Use enter to open file in new tab and ctrl t to replace the existing file
"let g:ctrlp_prompt_mappings = {
"    \ 'AcceptSelection("e")': ['<c-t>'],
"    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
"    \ }
"Always show correct location
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_javascript_jshint_conf = '~/.jshintrc'

"There are garbled text issues with syntastic https://github.com/scrooloose/syntastic/issues/822. So trigger it only on save
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
autocmd BufWritePost * :SyntasticCheck

"Show tab characters and eol
set listchars=tab:▸\ ,eol:¬

" Rename tabs to show tab number.
" (Based on http://stackoverflow.com/questions/5927952/whats-implementation-of-vims-default-tabline-function)
if exists("+showtabline")
    function! MyTabLine()
        let s = ''
        let wn = ''
        let t = tabpagenr()
        let i = 1
        while i <= tabpagenr('$')
            let buflist = tabpagebuflist(i)
            let winnr = tabpagewinnr(i)
            let s .= '%' . i . 'T'
            let s .= (i == t ? '%1*' : '%2*')
            let s .= ' '
            let wn = tabpagewinnr(i,'$')

            let s .= '%#TabNum#'
            let s .= i
            " let s .= '%*'
            let s .= (i == t ? '%#TabLineSel#' : '%#TabLine#')
            let bufnr = buflist[winnr - 1]
            let file = bufname(bufnr)
            let buftype = getbufvar(bufnr, 'buftype')
            if buftype == 'nofile'
                if file =~ '\/.'
                    let file = substitute(file, '.*\/\ze.', '', '')
                endif
            else
                let file = fnamemodify(file, ':p:t')
            endif
            if file == ''
                let file = '[No Name]'
            endif
            let s .= ' ' . file . ' '
            let i = i + 1
        endwhile
        let s .= '%T%#TabLineFill#%='
        let s .= (tabpagenr('$') > 1 ? '%999XX' : 'X')
        return s
    endfunction
    set stal=2
    set tabline=%!MyTabLine()
    set showtabline=1
    highlight link TabNum Special
endif
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
  endif
" JSDoc形式のコメントを追加(functionの行で実行する)
" hogeFunc: function() の形式と function hogeFunc() に対応
" 関数定義でない場合は、コメントだけ出力する
function! AddJSDoc()
    let l:jsDocregex = '\s*\([a-zA-Z]*\)\s*[:=]\s*function\s*(\s*\(.*\)\s*).*'
    let l:jsDocregex2 = '\s*function \([a-zA-Z]*\)\s*(\s*\(.*\)\s*).*'
 
    let l:line = getline('.')
    let l:indent = indent('.')
    let l:space = repeat("\t", l:indent)
 
    if l:line =~ l:jsDocregex
        let l:flag = 1
        let l:regex = l:jsDocregex
    elseif l:line =~ l:jsDocregex2
        let l:flag = 1
        let l:regex = l:jsDocregex2
    else
        let l:flag = 0
    endif
 
    let l:lines = []
    let l:desc = input('Description :')
    call add(l:lines, l:space. '/**')
    call add(l:lines, l:space . ' * ' . l:desc)
    if l:flag
        let l:funcName = substitute(l:line, l:regex, '\1', "g")
        let l:arg = substitute(l:line, l:regex, '\2', "g")
        let l:args = split(l:arg, '\s*,\s*')
        call add(l:lines, l:space . ' * @name ' . l:funcName)
        call add(l:lines, l:space . ' * @function')
        for l:arg in l:args
            call add(l:lines, l:space . ' * @param ' . l:arg)
        endfor
    endif
    call add(l:lines, l:space . ' */')
    call append(line('.')-1, l:lines)
endfunction
 
" JSDocのキーバインド
nmap ,d :<C-u>call AddJSDoc()<CR>
