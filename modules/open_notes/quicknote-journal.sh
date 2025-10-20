CONTENT="/mnt/localLuks/critical/open_notes/notes/$(date +'%Y%m%d-%H%M%S.journal.md')"
    echo "journal">> $CONTENT
    echo "++++"   >> $CONTENT
    echo ""       >> $CONTENT
    echo ""       >> $CONTENT
 
STARTUP=$(mktemp)
    echo "normal G" >> $STARTUP
    echo "i" >> $STARTUP

st -c QuickNote -f monospace:size=20 -g 80x20 \
 nvim -u $(quicknote-vimrc) -S $STARTUP $CONTENT 2>/dev/null
