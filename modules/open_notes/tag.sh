echo -e "# Setting variables\n"
echo "DIR_NOTES: $DIR_NOTES"
echo "DIR_TAGS:  $DIR_TAGS"
echo ""

echo -e "# Creating DIR_TAGS folder\n"
if [ -d "$DIR_TAGS" ]; then
  rm -r "$DIR_TAGS"
else
  echo "No directory present"
fi
mkdir "$DIR_TAGS"
echo

echo -e "# Linking tags\n"
find "$DIR_NOTES" -type f -print | \
  xargs -I {} tag_with_title $DIR_TAGS {}
find "$DIR_NOTES" -type f -print | \
  xargs -I {} tag_without_title $DIR_TAGS {}
find "$DIR_NOTES" -type f -exec tag-set-reminders {} \;



echo

