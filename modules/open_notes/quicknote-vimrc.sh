VIMRC=$(mktemp)
  # Remove status line
    echo "let s:hidden_all = 1"          >> $VIMRC
    echo "set noshowmode"                >> $VIMRC
    echo "set noruler"                   >> $VIMRC
    echo "set laststatus=0"              >> $VIMRC
    echo "set noshowcmd"                 >> $VIMRC
  
  # Remove empty lines from end of buffer
    echo "set fillchars=eob:\ "          >> $VIMRC
  
  # Miscellaneous
    echo "colorscheme catppuccin-frappe" >> $VIMRC
    echo "noremap q :wq<CR>"            >> $VIMRC
    echo "set textwidth=80"                  >> $VIMRC
    echo "set colorcolumn=90"                >> $VIMRC
    echo "set mouse=\"\""                    >> $VIMRC

echo  $VIMRC
