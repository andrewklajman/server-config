" globals
let g:mapleader = ","
let g:maplocalleader = ","
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_winsize = 20


set tabstop=2 softtabstop=2 shiftwidth=2
set expandtab
set number ruler
set autoindent smartindent
syntax enable
filetype plugin indent on

" options
set colorcolumn=90
set cursorline
set mouse=""
set nowrap
set relativenumber
set splitbelow
set splitright
set textwidth=80
colorscheme catppuccin-frappe

" General folding functions
set foldclose=all        " Close folds if you leave them in any way
set foldcolumn=3         " Show the foldcolumn
set foldenable           " Turn on folding
set foldlevel=0          " Autofold everything by default
"set foldmethod=syntax " Fold on the syntax
set foldnestmax=1        " I only like to fold outer functions
set foldopen=all         " Open folds if you touch them in any way

" keymaps
map <leader>l :Lexplore<CR>
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap z<CR> z<CR>2k2j
nnoremap <leader>g :w<CR>:!git add .<CR>q:1<C-W>_i!git commit -m ''<Esc>ha

" Mardown folds
au BufEnter *.md setlocal foldexpr=MarkdownLevel()  
au BufEnter *.md setlocal foldmethod=expr   
function! MarkdownLevel()
    if getline(v:lnum) =~ '^# .*$'
        return ">1"
    endif
    if getline(v:lnum) =~ '^## .*$'
        return ">2"
    endif
    if getline(v:lnum) =~ '^### .*$'
        return ">3"
    endif
    if getline(v:lnum) =~ '^#### .*$'
        return ">4"
    endif
    if getline(v:lnum) =~ '^##### .*$'
        return ">5"
    endif
    if getline(v:lnum) =~ '^###### .*$'
        return ">6"
    endif
    return "=" 
endfunction

" " gf alternative (open or create new link)
" autocmd BufEnter *.md inoremap <leader>wf <Esc>:call OCloneFile()<CR>
" function! OCloneFile()
"     normal viW"ay
"     if filereadable(@a)
"          execute('edit '..@a)
"     else
"          execute('new '..@a)
"     endif
" endfunction


nnoremap <leader>cl :colorscheme morning<CR>
nnoremap <leader>cd :colorscheme darkblue<CR>

" Cycle through color
let g:colors = getcompletion('', 'color')
nnoremap <leader>cn :let next_color='colorscheme '..NextColors()<CR>:execute next_color<CR>:echo next_color<CR>
func! NextColors()
    let idx = index(g:colors, g:colors_name)
    return (idx + 1 >= len(g:colors) ? g:colors[0] : g:colors[idx + 1])
endfunc

" " TaskWarrior reports [ Auto generate reports in taskreprots/ ]
" autocmd BufEnter ~/Documents/notes/taskreports/*.report call TaskReport()
" function! TaskReport()
"   if getcwd() == '/home/andrew/Documents/notes'
"     normal ggdG
"     execute('r!python3 scripts/task_report.py '..expand('%:t:r'))
"     w
"   endif
" endfunction

" init.vim folds
autocmd BufEnter init.vim setlocal foldexpr=InitVimLevel()  
autocmd BufEnter init.vim setlocal foldmethod=expr   
function! InitVimLevel()
    if getline(v:lnum) =~ '^" .*$'
        return ">1"
    endif
    return "=" 
endfunction

" Python Folding on functions
autocmd BufEnter *.py setlocal foldexpr=PythonDefLevel()  
autocmd BufEnter *.py setlocal foldmethod=expr   
function! PythonDefLevel()
    if getline(v:lnum) =~ '^def .*$'
        return ">1"
    endif
    return "=" 
endfunction

" Documents/notes vim file
if getcwd() == '/home/andrew/Documents/notes'

  nnoremap <leader>wcp :CtrlP /home/andrew/Documents/notes<CR>
  nnoremap <leader>gt :!python3 /home/andrew/Documents/notes/scripts/open-document-issues.py<CR>

" ./reports/task-by-tag
  autocmd BufEnter **/reports/tasks-by-tag call Tasks_by_tag()
  function! Tasks_by_tag()
    normal ggdG
    execute "r!./scripts/tasks-by-tag.sh"
    execute "write"
    normal gg
  endfunction

  " TaskWarrior tasks [ Modify, Add and Update tasks ]
  nnoremap <leader>ta :.!python3 scripts/task.py --add-task<CR>
  nnoremap <leader>tu :%!python3 scripts/task.py --update-task<CR>
  autocmd BufEnter *.md call TaskUpdate()
  function! TaskUpdate()
    if getcwd() == '/home/andrew/Documents/notes'
      %!python3 scripts/task.py --update-task
    endif
  endfunction

endif

