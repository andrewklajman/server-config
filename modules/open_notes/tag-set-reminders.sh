FILE=$1
grep 'when:' "$FILE" || exit
RESULT=$(grep 'when:' "$FILE")
WHEN=$(echo $RESULT | cut -d' ' -f2)

TAG_INS="1i$(echo $RESULT | cut -d' ' -f4)"
[ $(date +%s) -ge $(date -d $WHEN +%s) ] && sed -i $TAG_INS $FILE
TAG_DEL="/when:.*$(echo $RESULT | cut -d' ' -f4)/d"
[ $(date +%s) -ge $(date -d $WHEN +%s) ] && sed -i $TAG_DEL $FILE
