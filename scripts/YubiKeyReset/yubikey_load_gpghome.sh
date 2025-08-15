SECURITY_DEVICE="/dev/sda1" # ................. Encrypted USB Device 
SECURITY_DEVICE_MNT=$(mktemp -d) # ............ Mount point of USB Device
GNUPGHOME="$SECURITY_DEVICE_MNT/gnupg-2024-09-09-nMEuHHsj7e/" # gpghome on USB Device
TMPFS_DIR="/root/KEY" # .... Place to copy gnupg to
clear

echo --- Cleaning Up ---
  umount $TMPFS_DIR
  echo

echo --- Variables ---
  echo "SECURITY_DEVICE:     $SECURITY_DEVICE"
  echo "SECURITY_DEVICE_MNT: $SECURITY_DEVICE_MNT"
  echo "GNUPGHOME:           $GNUPGHOME"
  echo "TMPFS_DIR:           $TMPFS_DIR"
  echo

echo --- Copying Files ---
  mkdir -p $TMPFS_DIR
  mount -t tmpfs -o size=100M tmpfs $TMPFS_DIR
  cryptsetup open $SECURITY_DEVICE usb
  mount /dev/mapper/usb $SECURITY_DEVICE_MNT
  cp -r $GNUPGHOME $TMPFS_DIR
  umount $SECURITY_DEVICE_MNT
  cryptsetup close usb

