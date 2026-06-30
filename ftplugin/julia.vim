let g:ycm_disable_signature_help = 1      " For some reson signature help crashes often
autocmd TextChanged <buffer> silent write " Autosave

" Custom maps
" (un)comment line
nnoremap <leader>/ I#<esc>
nnoremap <leader>u/ $F#x
