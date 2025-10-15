DIR="/mnt/localLuks/Documents/open_notes/audio"
FILEPATH=$(date "+$DIR/%Y%m%d-%H%M%S")
ST_COMMAND="arecord -r 48000 -c 2 -f S16_LE $FILEPATH.wav"
#ST_COMMAND="rec $FILEPATH.aiff"
st -c OpenNotesAudio $ST_COMMAND
