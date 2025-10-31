CONTENT=$(mktemp)
    echo "quicknote-add-food" >> $CONTENT
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

# TODO need to modify RunCommand to open the script in st

  # Opening scripts
    echo "nnoremap <CR> :call RunCommand()<CR>" >> $VIMRC
    echo "function! RunCommand()" >> $VIMRC
    echo "execute \"!\"..getline(\".\")" >> $VIMRC
    echo "normal q" >> $VIMRC
    echo "endfunction" >> $VIMRC

#  # Opening scripts w st
#    #echo "nnoremap <CR> :call RunCommandSt()<CR>" >> $VIMRC
#    echo "function! RunCommandSt()" >> $VIMRC
#    echo "execute \"!st -c QuickNote -f monospace:size=20 -g 80x20 \"..getline(\".\")" >> $VIMRC
#    echo "normal q" >> $VIMRC
#    echo "endfunction" >> $VIMRC



nvim -u $VIMRC $CONTENT 2>/dev/null
