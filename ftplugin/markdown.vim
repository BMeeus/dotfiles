let b:ale_completion_enabled = 1
let b:ale_fixers = ['prettier', 'markdownlint']
let b:ale_fix_on_save = 1

command -nargs=? Obs call s:OpenInObsidian(<q-args>)
noremap <silent> <c-o> :call <SID>OpenWikiLink()<CR>
nnoremap <leader>c vT\|ot\|yf\|p
nnoremap <leader>f <cmd>TableFormat<CR>

function! s:OpenInObsidian(arg)
    let l:target = empty(a:arg) ? expand('%') : a:arg
    execute 'silent !obsidian open file='.shellescape(l:target)
endfunction

function! s:OpenWikiLink()
    let l:saved_reg = getreg('"')
    let l:saved_regtype = getregtype('"')

    " Get text inside link, ignore display text, section ref
    silent! normal! yi]
    let l:link = split(split(getreg('"'), '|')[0], '#')[0]

    " Restore default register
    call setreg('"', l:saved_reg, l:saved_regtype)

    if !empty(l:link)
        call s:OpenInObsidian(l:link)
    else
        echo "No link found under cursor."
    endif
endfunction
