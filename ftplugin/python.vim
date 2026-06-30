set nowrap " Don't wrap lines at all
autocmd TextChanged <buffer> silent write " Autosave

" File format settings
set textwidth=79
set fileformat=unix

" Custom maps
" (un)comment line
nnoremap <leader>/ I#<esc>
nnoremap <leader>u/ $F#x

nnoremap <C-Enter> <cmd>!python3 %<CR>  
