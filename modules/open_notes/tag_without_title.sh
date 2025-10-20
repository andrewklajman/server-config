DIR_TAGS=$1
FILEPATH_NOTE=$2

echo "DIR_TAGS: $DIR_TAGS"
echo "FILEPATH_NOTE: $FILEPATH_NOTE"
echo 
#DIR_TAGS="/tmp/tags"
#FILEPATH_NOTE="/mnt/localLuks/critical/open_notes/notes/20251020-064503.journal.md"

echo Attempting $FILEPATH_NOTE

grep -e '^title:' $FILEPATH_NOTE &>> /dev/null
[ $? -eq 0 ] && exit

FILENAME_TAG="${FILEPATH_NOTE##*/}"

echo "ln -s (without title)\ "
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
