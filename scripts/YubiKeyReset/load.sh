mount -t tmpfs -o size=100M tmpfs /persist/YubiKeyReset/DELETE
cryptsetup open /dev/sda1 usb
mount /dev/mapper/usb usb
cp -r usb/gnupg-2024-09-09-nMEuHHsj7e/ DELETE/
umount usb
cryptsetup close usb


