DIR_TAGS=$1
FILEPATH_NOTE=$2

grep -e '^title:' $FILEPATH_NOTE &>> /dev/null
[ $? -ne 0 ] && exit

TITLE=$(grep 'title:' $FILEPATH_NOTE | cut -d':' -f2 | head -n1)
TITLE=$(tr -d  '\n\t\r' <<< "$TITLE")
FILENAME_TAG=$(xargs <<< "$TITLE").md

echo "ln -s (with title)\ "
echo "    $FILEPATH_NOTE \ "

while read DIR_TAG; do
  if [ "$DIR_TAG" == "++++" ]; then
    echo ""
    exit
  fi
  mkdir -p "$DIR_TAGS/$DIR_TAG"
  FILEPATH_TAG="$DIR_TAGS/$DIR_TAG/$FILENAME_TAG"
  echo "    .... $FILEPATH_TAG"
  ln -s "$FILEPATH_NOTE" "$FILEPATH_TAG"
done<$FILEPATH_NOTE
