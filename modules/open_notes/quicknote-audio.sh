FILEPATH="$(date +/mnt/localLuks/Documents/open_notes/audio/%Y%m%d-%H%M%S.testing.ogg)"
ST_COMMAND="arecord -f cd -t raw | oggenc -- -r -o $FILEPATH"
echo $ST_COMMAND
st -c OpenNotesAudio $ST_COMMAND
