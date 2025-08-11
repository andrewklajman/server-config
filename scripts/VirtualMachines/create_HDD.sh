TYPE="vhdx" # raw, qcow2, vhdx
NAME="pin11"
SIZE="100M"

FULLNAME=$NAME"."$TYPE

qemu-img create \
  -f "$TYPE" \
  "$FULLNAME" \
  "$SIZE"
