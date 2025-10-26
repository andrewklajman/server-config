DIR="/mnt/localLuks/critical/open_notes/notes"
DATETIME=$(date +'%Y%m%d-%H%M%S')

CONTENT="$DIR/$DATETIME.health.md"
    echo "health"                                      >> $CONTENT
    echo "health/Blood Pressure"                       >> $CONTENT
    echo "health/PulseRate"                            >> $CONTENT
    echo "health/Oximeter"                             >> $CONTENT
    echo "health/Weight"                               >> $CONTENT
    echo "health/Waist"                                >> $CONTENT
    echo "++++"                                        >> $CONTENT
    echo ""                                            >> $CONTENT
    echo "title: Health Record $(date +%Y%m%d-%H%M%S)" >> $CONTENT
    echo ""                                            >> $CONTENT
    echo "Blood Pressure:  "                           >> $CONTENT
    echo "Pulse Rate    : "                            >> $CONTENT
    echo "Oximeter      : "                            >> $CONTENT
    echo "Waist         : "                            >> $CONTENT
    echo "Notes         : "                            >> $CONTENT
 
STARTUP=$(mktemp)
    echo "normal 11GA"  >> $STARTUP
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
  tail -n $(grep -n '++++' $CONTENT | cut -d':' -f1) $CONTENT > $DATA
  VAL=$(grep -e "$MEASUREMENT" $DATA | cut -d':' -f2 | xargs)

  echo "$DATETIME,$VAL" >> "$LOG"
}

record_log "Blood Pressure"
record_log "Pulse Rate"
record_log "Oximeter"
record_log "Waist"
