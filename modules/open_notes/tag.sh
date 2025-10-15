#DIR_NOTES="/home/andrew/luks/Documents/open_notes/notes"
#DIR_TAGS="/home/andrew/luks/Documents/open_notes/tags"
#DIR_NOTES=$1
#DIR_TAGS=$2
#LOG="$(${pkgs.coreutils}/bin/date +$DIR_NOTES/%Y%m%d-%H%M%S.md)"
LOG="$(date +$DIR_NOTES/%Y%m%d-%H%M%S.md)"

echo "logs/open-notes" 2>&1 | tee --append $LOG
echo "++++" 2>&1 | tee --append $LOG
echo "" 2>&1 | tee --append $LOG

echo "" 2>&1 | tee --append $LOG
echo $LOG
echo "" 2>&1 | tee --append $LOG

echo -e "# Setting variables\n" 2>&1 | tee --append $LOG
echo "DIR_NOTES: $DIR_NOTES" 2>&1 | tee --append $LOG
echo "DIR_TAGS:  $DIR_TAGS" 2>&1 | tee --append $LOG
echo "" 2>&1 | tee --append $LOG

echo -e "# Creating DIR_TAGS folder\n" 2>&1 | tee --append $LOG
if [ -d "$DIR_TAGS" ]; then
  rm -r "$DIR_TAGS" 2>&1 | tee --append $LOG
else
  echo "No directory present" 2>&1 | tee --append $LOG
fi
mkdir "$DIR_TAGS" 2>&1 | tee --append $LOG
echo

echo -e "# Linking tags\n" 2>&1 | tee --append $LOG
find "$DIR_NOTES" -type f -print | xargs -I {} tag_with_title "$DIR_TAGS" {} 2>&1 | tee --append $LOG
find "$DIR_NOTES" -type f -print | xargs -I {} tag_without_title "$DIR_TAGS" {} 2>&1 | tee --append $LOG
# find "$DIR_NOTES" -type f -print | xargs -I {} tag_audio "$DIR_AUDIO" {} 2>&1 | tee --append $LOG

