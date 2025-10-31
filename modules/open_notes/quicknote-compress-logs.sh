DIR="/mnt/localLuks/critical/open_notes"

FNAME_BACKUP="$DIR/archive/log.tag.md.$(date +'%Y%m%d-%H%M%S').tar.gz"

find "$DIR/notes" ! -newermt yesterday -type f -name '*.log.tag.md' -print0 | \
  tar -cvzf $FNAME_BACKUP --null -T -

find "$DIR/notes" ! -newermt yesterday -type f -name '*.log.tag.md' -delete
