DIR="/mnt/localLuks/critical/open_notes/notes"
DATETIME=$(date +'%Y%m%d-000000')

# Initialisation
  FOOD_DB="$DIR/20251028-000000.food.db"
  FOOD_LOG="$DIR/$DATETIME.food.log"

# Get result of fzf
  FOOD_DB_TOT_LINES=$(wc -l $FOOD_DB | cut -d' ' -f1)
  TAIL_AMNT=$(($FOOD_DB_TOT_LINES - 2))

  COMM_FZF=$(mktemp)
  COMM_RES=$(mktemp)
  echo "tail --lines=$TAIL_AMNT $FOOD_DB | fzf > $COMM_RES" > $COMM_FZF
  chmod +x $COMM_FZF
  st -c QuickNote -f monospace:size=20 -g 80x20 \
     -e $COMM_FZF

# Create food log if necessary
  if [ ! -f $FOOD_LOG ]; then 
    echo "health/FoodRecord"                 >> $FOOD_LOG
    echo "++++"                            >> $FOOD_LOG
    echo ""                                >> $FOOD_LOG
    echo "title: Food Log $(date)"         >> $FOOD_LOG
    echo ""                                >> $FOOD_LOG
    echo "| Timestamp | Food | Calories |" >> $FOOD_LOG
    echo "| --------- + ---- + -------- |" >> $FOOD_LOG
  fi

# Add timestemp and append to log
  RESULT="| $(date +%Y%m%d-%H%M%S) $(cat $COMM_RES)"
  echo $RESULT >> $FOOD_LOG

# Open in nvim in case of needed modification
  VIMRC=$(quicknote-vimrc)
  STARTUP=$(mktemp)
    echo "normal G"  >> $STARTUP
  st -c QuickNote -f monospace:size=20 -g 80x20 \
    nvim -u $VIMRC -S $STARTUP $FOOD_LOG 2>/dev/null

