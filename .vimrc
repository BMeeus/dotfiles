set runtimepath+=~/vim/runtime
source $VIMRUNTIME/vimrc_example.vim

" Vim admin files settings -----{{{
set undodir=~/.vim/undo
set undofile
set backup
set backupdir=~/.vim/vimtmp/,.
set directory=~/.vim/vimtmp/,.
"}}}

" Vim autosave -----{{{
" autocmd TextChanged <buffer> silent write
"}}}

" Vim settings -----{{{
set hlsearch                " Highlight search results
set incsearch               " Match search results while typing
packadd nohlsearch          " Make search highlight disappear automatically
set number relativenumber   " Absolute line nr at cursor, others relative
set conceallevel=2          " Conceal twice
set guifont=JetBrains\ mono " Use JetBrains mono (https://www.jetbrains.com/lp/mono/)
set breakindent             " Wrapped lines maintain indent
set nofoldenable            " Open all folds when opening file

" The following settings should be overwritten in ftplugin files, keep this as fallback
set formatoptions=l         " Don't break lines longer than textwidth
set linebreak               " Break lines semantically, not at last char on screen
set tabstop=8               " Amount of actual spaces per tab. Don't touch!
set softtabstop=4           " Amount of spaces per tab inserted. Feel free to change
set shiftwidth=4            " Amount of spaces per visual indent, keep same as sts
"}}}

" Plugin loads -----{{{
call plug#begin()
Plug 'lervag/vimtex'
Plug 'arcticicestudio/nord-vim'
Plug 'SirVer/ultisnips'
Plug 'dense-analysis/ale'
Plug 'KeitaNakamura/tex-conceal.vim', {'for': 'tex'}
Plug 'Valloric/YouCompleteMe'
Plug 'junegunn/vader.vim'
Plug 'Konfekt/FastFold'
Plug 'tmhedberg/SimpylFold'
Plug 'vim-scripts/indentpython.vim'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree-project-plugin'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tmsvg/pear-tree'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'ycm-core/lsp-examples'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npx --yes yarn install' }
call plug#end()
"}}}

" Plugin settings -----{{{
" VimTex -----{{{
	let g:vimtex_view_method = 'zathura_simple'
	let g:vimtex_imaps_enabled = 0
	let g:vimtex_syntax_enabled = 0
	let g:vimtex_compiler_latexmk = {"aux_dir" : "./aux"}
	let g:vimtex_quickfix_mode=0
"}}}

" UltiSnips -----{{{
	let g:UltiSnipsExpandOrJumpTrigger='<tab>'
	let g:UltiSnipsJumpBackwardTrigger='<S-Tab>'
	let g:UltiSnipsSnippetDirectories=[$HOME.'/.vim/UltiSnips']
"}}}

" Tex-conceal -----{{{
	let g:tex_superscripts= "[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]"
	let g:tex_subscripts= "[1, 2, 3, 4, 5, 6, 7, 8, 9, 0]"
	let g:tex_conceal_frac=1
	let g:tex_conceal='abdmg'
	let g:tex_flavor='latex'
"}}}

" YCM ----{{{
	let g:ycm_key_list_select_completion = ['<Down>']
"}}}

" FastFold----{{{
	let g:fastfold_savehook=1
	let g:fastfold_fold_command_suffixes =  ['x','X','a','A','o','O','c','C']
	let g:fastfold_fold_movement_commands = [']z', '[z', 'zj', 'zk']
"}}}

" NERDTree----{{{
	let NERDTreeIgnore=['\.synctex.gz$','\~$']
"}}}
"}}}

" VimTex - YCM connection -----{{{
if !exists('g:ycm_semantic_triggers')
let g:ycm_semantic_triggers = {}
endif
au VimEnter * let g:ycm_semantic_triggers.tex=g:vimtex#re#youcompleteme
"}}}
 
" Colors -----{{{
colorscheme nord
"}}}

" Enable spellcheck -----{{{
setlocal spell
set spelllang=en_us
set complete-=i
"}}}

" ALE Linter settings -----{{{
let g:ale_linters = {'tex': ['chktex', 'texlab'], 'julia': ['languageserver']}
let g:ale_tex_chktex_options = '-I -n1 -n3 -n8 -n11 -n10 -n15 -n44 -n46 -n48'
"}}}

" YCM settings -----{{{
let g:ycm_autoclose_preview_window_after_completion=1
noremap <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
let g:ycm_language_server = [
			\   { 
			\     'name': 'julia',
			\     'filetypes': [ 'julia' ],
			\     'project_root_files': [ 'Project.toml' ],
			\	'cmdline': ['julia', '--startup-file=no', '--history-file=no', '-e', '
			\       using LanguageServer;
			\       using Pkg;
			\       import StaticLint;
			\       import SymbolServer;
			\       env_path = dirname(Pkg.Types.Context().env.project_file);
			\       
			\       server = LanguageServer.LanguageServerInstance(stdin, stdout, env_path, "");
			\       server.runlinter = true;
			\       run(server);
			\   ']
			\  },
			\ ]
source /home/bmeeus/.vim/plugged/lsp-examples/vimrc.generated
"}}}

" Custom maps -----{{{
" General -----{{{
nnoremap <Space> <Nop>
let mapleader=" "

" Easy vimrc editing
nnoremap <leader>ev <Cmd>vsplit $MYVIMRC<cr>
nnoremap <leader>sv <Cmd>source $MYVIMRC<cr>

" Easy exiting
inoremap sd <esc>

" Easy fold toggling
nnoremap <leader><leader> za
"}}}

" Text editing -----{{{

" Correct previous spelling mistake
inoremap <C-l> <C-g>u<Esc>[s1z=``a<C-g>u
nnoremap <leader>l <C-g>u[s1z=``<C-g>u

" Add previous spelling mistake to spell list
inoremap <C-k> <Esc>[s1zg``a
nnoremap <leader>k [s1zg``

" Use omnicomplete
inoremap <C-c> <C-x><C-o>

" Do last motion + action again
nnoremap <leader>a ;.

" Start new line here
nnoremap <leader>i ko
"}}}

" Navigation -----{{{

" Make H and L work like ^ and $ in all contexts
nnoremap H ^
nnoremap L $
onoremap H ^
onoremap L $
vnoremap H ^
vnoremap L $

" Move trough windows
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Add blank lines
noremap <Enter> o<Esc>
noremap <S-Enter> O<Esc>

" Open NERDTree
noremap <C-E> <Cmd>NERDTree<cr>
nnoremap <leader>n <Cmd>NERDTreeFocus<cr>

" GoTos van YCM
nmap <silent> gd :YcmCompleter GoToDefinition<CR>
nmap <silent> gr :YcmCompleter GoToReferences<CR>
"}}}

" Spell settings -----{{{
command SpellNL execute "set spelllang=nl | set spellfile=~/.vim/spell/nl.utf-8.add"
command SpellEN execute "set spelllang=en_us | set spellfile=~/.vim/spell/en.utf-8.add"
" }}}

" Training -----{{{
" These take away undesirable actions
inoremap <esc> <nop>
inoremap <Up> <nop>
inoremap <Left> <nop>
inoremap <Right> <nop>
"}}}
"}}}

nohlsearch " Do not question it
