DIR_NOTES="/mnt/localLuks/critical/open_notes/notes"
DIR_SCRIPT="/home/andrew/server-config/modules/open_notes"
DIR_TAGS="/home/andrew/server-config/modules/open_notes/debug/tags"
TAG_WO_TITLE="$DIR_SCRIPT/tag_without_title.sh"
LOG="$(mktemp)"

rm -r $DIR_TAGS
mkdir $DIR_TAGS

find "$DIR_NOTES" -type f -print | \
  xargs -I {} $TAG_WO_TITLE $DIR_TAGS {} 2>&1 | \
  tee --append $LOG




#echo "# Journal not being tagged"
#FILEPATH_NOTE="$DIR_NOTES/20251020-064503.journal.md"
##FILEPATH_NOTE="$DIR_NOTES/20251002-1955.md"
#echo 
#
#echo "## Content"
#echo 
#cat $FILEPATH_NOTE
#echo 
#
#echo "## Tagging"
#echo 
#echo "$TAG_WO_TITLE \"$DIR_TAG\" \"$FILEPATH_NOTE\""
#echo 
#bash $TAG_WO_TITLE "$DIR_TAG" "$FILEPATH_NOTE"
#echo 


