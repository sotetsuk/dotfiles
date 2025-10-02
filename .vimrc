"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
set number
set encoding=utf-8
set belloff=all
set backspace=indent,eol,start
set noswapfile
" tab
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab
set autoindent
set smartindent
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.py setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.h setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.c setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.cc setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.cp setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.cpp setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.cxx setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.hpp setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.tsv setlocal noexpandtab
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Install vim-plug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Manage plugins
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin('~/.vim/plugged')
" Plug 'cohama/lexima.vim'
" Plug 'jiangmiao/auto-pairs'
" LSP and auto-completion
" Plug 'prabirshrestha/vim-lsp'
" Plug 'mattn/vim-lsp-settings'
" Plug 'prabirshrestha/asyncomplete.vim'
" Plug 'prabirshrestha/asyncomplete-lsp.vim'
" Color theme
Plug 'sickill/vim-monokai', {'do': 'mkdir -p ~/.vim/colors && cp ~/.vim/plugged/vim-monokai/colors/* ~/.vim/colors/'}
" fzf
" Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
" Plug 'junegunn/fzf.vim'
Plug 'github/copilot.vim'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin variables
"""""""""""""""""""""""""""""""""""""""""""""""""""""""
" NERDTree
" nmap <C-n> :NERDTreeToggle<CR>
" let g:NERDTreeQuitOnOpen = 1

" LSP
" let g:lsp_diagnostics_echo_cursor = 1  " show dianostics message on bar
" autocmd BufWritePre <buffer> LspDocumentFormatSync  " apply format on save
" :command F LspDocumentFormatSync  " alias for applying format
" let g:lsp_diagnostics_signs_error = {'text': '✗‣'}
" let g:lsp_diagnostics_signs_warning = {'text': ' ‣'}
" let g:lsp_diagnostics_signs_information = {'text': ' ‣'}
" let g:lsp_diagnostics_signs_hint = {'text': ' ‣'}

" Color theme
silent! colorscheme monokai

