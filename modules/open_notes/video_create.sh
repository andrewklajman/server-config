DIR="/mnt/localLuks/Documents/open_notes/video"
FILEPATH=$(date "+$DIR/%Y%m%d-%H%M%S")



#TEE="output.mp4|[f=nut]pipe:"
#ffmpeg -f v4l2 -i /dev/video0 -map 0 -c:v libx264 -f tee $TEE | ffplay pipe:

ffmpeg \
  -f alsa \
  -ac 2 \
  -i default \
  -itsoffset 00:00:00.5 \
  -f video4linux2 \
  -s 320x240 \
  -r 25 \
  -i /dev/video0 \
  $FILEPATH.mp4 | ffplay -

##FFMPEG_PID=$!
#
#ffplay \
#  -f video4linux2 \
#  -i /dev/video0 \
#  -video_size 320x240 \
#  -fflags nobuffer
#
#
#
#
#
