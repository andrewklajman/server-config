echo '--- Setting Variables ---'
DISK="/dev/sda"
PART1="/dev/sda1"
PART2="/dev/sda2"
PART3="/dev/sda3"
PART4="/dev/sda4"
PART5="/dev/sda5"

echo '--- Partitioning (UEFI) ---'
parted $DISK -- mklabel msdos
parted $DISK -- mkpart primary              1MB 512MB # /boot
parted $DISK -- mkpart primary            512MB 100GB # /nix
parted $DISK -- mkpart primary            100GB 110GB # /mnt/persist
parted $DISK -- mkpart primary linux-swap -10GB  100% # swap

echo '--- Formatting Disks ---'
mkfs.ext4 -q -L boot    $PART1
mkfs.ext4 -q -L nix     $PART2
mkfs.ext4 -q -L persist $PART3
mkswap    -q -L swap    $PART4
swapon $PART5

echo '--- Mounting Disks ---'
mount -t tmpfs -o size=1G tmpfs /mnt
mkdir -p /mnt/boot /mnt/nix /mnt/mnt/persist
mount /dev/disk/by-label/boot /mnt/boot
mount /dev/disk/by-label/nix /mnt/nix
mount /dev/disk/by-label/persist /mnt/mnt/persist

echo '--- Generating and Adjust Config ---'
nixos-generate-config --root /mnt

echo '--- Post Hardware to Web ---'
cat /mnt/etc/hardware-configuration.nix | nc termbin.com 9999
