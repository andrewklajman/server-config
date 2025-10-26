DIR="/mnt/localLuks/critical/open_notes/notes"
DATETIME=$(date +'%Y%m%d-%H%M%S')

CONTENT="$DIR/$DATETIME.health.md"
    echo "health"                                      >> $CONTENT
    echo "health/Weight"                               >> $CONTENT
    echo "health/Exercise"                               >> $CONTENT
    echo "++++"                                        >> $CONTENT
    echo ""                                            >> $CONTENT
    echo "title: Exercise Record $(date +%Y%m%d-%H%M%S)" >> $CONTENT
    echo ""                                            >> $CONTENT
    echo "Weight  :  "                            >> $CONTENT
    echo "Running : "                            >> $CONTENT
    echo "Pushups : "                            >> $CONTENT
    echo "Squats  : "                            >> $CONTENT
    echo "Rows    : "                            >> $CONTENT
    echo "Notes   : "                            >> $CONTENT
 
STARTUP=$(mktemp)
    echo "normal 8GA"  >> $STARTUP
    echo "startinsert" >> $STARTUP

VIMRC=$(quicknote-vimrc)
    echo "inoremap n <ESC>ja" >> $VIMRC


st \
 -c QuickNote \
 -f monospace:size=20 \
 -g 80x20 \
 nvim -u $VIMRC -S $STARTUP $CONTENT 2>/dev/null

record_log() {
  local MEASUREMENT=$1
  LOG="$DIR/$MEASUREMENT.log"

  DATA=$(mktemp)
  HEADER_LINE_NUM=$(grep -n '++++' $CONTENT | cut -d':' -f1)
  TOT_LINE_NUM=$(wc -l $CONTENT | cut -d' ' -f1)
  CONTENT_TAIL=$(( $TOT_LINE_NUM - $HEADER_LINE_NUM ))
  tail -n $CONTENT_TAIL $CONTENT > $DATA
  VAL=$(grep -e "$MEASUREMENT" $DATA | cut -d':' -f2 | xargs)

  echo "$DATETIME,$VAL" >> "$LOG"
}

record_log "Weight"
record_log "Running"
record_log "Pushups"
record_log "Squats"
record_log "Rows"
