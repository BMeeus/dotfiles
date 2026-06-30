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
