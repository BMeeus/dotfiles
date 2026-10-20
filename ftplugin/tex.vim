let g:tex_indent_items=0

" (un)comment line
nnoremap <leader>/ I%<esc>
nnoremap <leader>u/ $F%x
noremap <C-Enter> <Cmd>update<CR><Plug>(vimtex-compile-ss)

" Put word/visual in math mode
nnoremap <leader>m viw<esc>a$<esc>bi$<esc>
vnoremap <leader>m <esc>`>a$<esc>`<i$<esc>

" Make j, k scroll visual lines and J, K scroll actual lines
nnoremap J j
nnoremap K k
vnoremap J j
vnoremap K k
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

" Insert todo
nnoremap <leader>td i\todo{}
inoremap <localleader>td \todo{}<esc>i

" Toggle draft
command DraftOn execute "normal! ggf]i,draft<Esc>``"
command DraftOff execute "normal! gg/,draft<Esc>d6l``"
command ToggleDraft call ToggleLatexDraft()

function! ToggleLatexDraft() abort
    let l:line = getline(1)
    
    " Check if line 1 contains \documentclass
    if l:line !~# '\\documentclass'
        echohl WarningMsg
        echo "Line 1 does not contain \\documentclass"
        echohl None
        return
    endif

    " Case 1: ',draft' exists -> remove it
    if l:line =~# ',draft\>'
        let l:new_line = substitute(l:line, ',draft\>', '', '')
        call setline(1, l:new_line)
        echo "LaTeX draft mode disabled"

    " Case 2: 'draft,' exists (e.g. \documentclass[draft,12pt]{article}) -> remove it
    elseif l:line =~# '\<draft,'
        let l:new_line = substitute(l:line, '\<draft,', '', '')
        call setline(1, l:new_line)
        echo "LaTeX draft mode disabled"

    " Case 3: 'draft' is the only option (e.g. \documentclass[draft]{article}) -> remove 'draft'
    elseif l:line =~# '\[\s*draft\s*\]'
        let l:new_line = substitute(l:line, '\[\s*draft\s*\]', '', '')
        call setline(1, l:new_line)
        echo "LaTeX draft mode disabled"

    " Case 4: Options bracket exists -> append ',draft' inside brackets
    elseif l:line =~# '\[.\{-}\]'
        let l:new_line = substitute(l:line, '\]', ',draft]', '')
        call setline(1, l:new_line)
        echo "LaTeX draft mode enabled"

    " Case 5: No options bracket exists -> insert '[draft]' before '{'
    else
        let l:new_line = substitute(l:line, '\\documentclass', '\\documentclass[draft]', '')
        call setline(1, l:new_line)
        echo "LaTeX draft mode enabled"
    endif
endfunction


