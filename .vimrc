set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'ctrlp.vim'
Plugin 'syntastic'
Plugin 'tpope/vim-fugitive'
Plugin 'heavenshell/vim-jsdoc'
Plugin 'tpope/vim-commentary'
Plugin 'scrooloose/nerdtree'
call vundle#end()

"Change syntax error highlighti color
hi clear SpellBad
hi SpellBad cterm=underline,bold ctermfg=white ctermbg=red
syntax enable


set list
set tabstop=4
set shiftwidth=4
set nu
set hlsearch
set ai

map <F5> :redraw!<CR>
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

let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_user_command =
    \ ['.git', 'cd %s && git ls-files . -co --exclude-standard']
let g:ctrlp_working_path_mode = 'c' 


"CtrlP config: Use enter to open file in new tab and ctrl t to replace the existing file
"let g:ctrlp_prompt_mappings = {
"    \ 'AcceptSelection("e")': ['<c-t>'],
"    \ 'AcceptSelection("t")': ['<cr>', '<2-LeftMouse>'],
"    \ }
"Always show correct location
let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
let g:syntastic_javascript_jshint_conf = '~/.jshintrc'

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
