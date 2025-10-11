pkgs:

pkgs.writeShellScriptBin "tag_without_title" '' 

   DIR_TAGS=$1
   FILEPATH_NOTE=$2
   
   grep -e '^title:' $FILEPATH_NOTE &>> /dev/null
   [ $? -eq 0 ] && exit
   
   FILENAME_TAG="''${FILEPATH_NOTE##*/}"

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
''
