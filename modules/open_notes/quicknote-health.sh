DIR="/mnt/localLuks/critical/open_notes/notes"
DATETIME=$(date +'%Y%m%d-%H%M%S')

CONTENT="$DIR/$DATETIME.health.md"
    echo "health/HealthRecord"                                >> $CONTENT
    echo "++++"                                        >> $CONTENT
    echo ""                                            >> $CONTENT
    echo "title: Health Record $(date +%Y%m%d-%H%M%S)" >> $CONTENT
    echo ""                                            >> $CONTENT
    echo "Blood Pressure:  "                           >> $CONTENT
    echo "Pulse Rate    : "                            >> $CONTENT
    echo "Oximeter      : "                            >> $CONTENT
    echo "Waist         : "                            >> $CONTENT
    echo "Back          : "                            >> $CONTENT
 
STARTUP=$(mktemp)
    echo "normal 6GA"  >> $STARTUP
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
  echo MEASUREMENT: $MEASUREMENT

  LOG="$DIR/$MEASUREMENT.log"
  echo LOG: $LOG

  # Exclude tags at beginning of file
  DATA=$(mktemp)
  #tail -n $(grep -n '++++' $CONTENT | cut -d':' -f1) $CONTENT > $DATA
  PLUS_LINE_NUM=$(grep -n '++++' $CONTENT | cut -d':' -f1)
  TOT_LINE_NUM=$(cat $CONTENT | wc -l)
  CONTENT_TAIL=$(($TOT_LINE_NUM - PLUS_LINE_NUM))
  tail -n $CONTENT_TAIL $CONTENT > $DATA

  VAL=$(grep -e "$MEASUREMENT" $DATA | cut -d':' -f2 | xargs)
  echo "$DATETIME,$VAL" >> "$LOG"
}

record_log "Blood Pressure"
record_log "Pulse Rate"
record_log "Oximeter"
record_log "Waist"
