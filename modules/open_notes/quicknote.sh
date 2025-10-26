CONTENT=$(mktemp)
    echo "quicknote-journal" >> $CONTENT
    echo "quicknote-health" >> $CONTENT
    echo "quicknote-exercise" >> $CONTENT

VIMRC=$(mktemp)
  # Remove status line
    echo "let s:hidden_all = 1" >> $VIMRC
    echo "set noshowmode" >> $VIMRC
    echo "set noruler" >> $VIMRC
    echo "set laststatus=0" >> $VIMRC
    echo "set noshowcmd" >> $VIMRC
  
  # Remove empty lines from end of buffer
    echo "set fillchars=eob:\ " >> $VIMRC
  
  # Miscellaneous
    echo "colorscheme darkblue" >> $VIMRC
    echo "nnoremap q :q!<CR>" >> $VIMRC
  
  # Opening scripts
    echo "nnoremap <CR> :call RunCommand()<CR>" >> $VIMRC
    echo "function! RunCommand()" >> $VIMRC
    echo "execute \"!\"..getline(\".\")" >> $VIMRC
    echo "normal q" >> $VIMRC
    echo "endfunction" >> $VIMRC

nvim -u $VIMRC $CONTENT 2>/dev/null
