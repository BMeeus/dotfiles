set nowrap " Don't wrap lines at all

" Indent settings
set tabstop=4
set softtabstop=4
set shiftwidth=4
set textwidth=79
set expandtab
set autoindent
set fileformat=unix

" Custom maps
" (un)comment line
nnoremap <leader>/ 0I#<esc>
nnoremap <leader>u/ $F#x

nnoremap <C-Enter> <cmd>!python3 %<CR>  
