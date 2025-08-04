# # Partition (MBR)
# parted /dev/ -- mklabel msdos
# parted /dev/ -- mkpart primary 1MB -8GB
# parted /dev/ -- mkpart primary linux-swap -8GB 100%

echo '--- Setting Variables ---'
DISK="/dev/"
PART1="/dev/"
PART2="/dev/"
PART3="/dev/"
PART4="/dev/"
PART5="/dev/"

echo '--- Partitioning (UEFI) ---'
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MB 512MB
parted $DISK -- mkpart nix ext4 512MB 100GB
parted $DISK -- mkpart persist ext4 100GB 150GB
parted $DISK -- mkpart persist-enc ext4 150GB 220GB
parted $DISK -- mkpart swap linux-swap 220GB 100%
parted $DISK -- set 5 esp on

echo '--- Disk Encryption ---'
cryptsetup luksFormat $PART4
cryptsetup open /dev/ persist-enc

echo '--- Formatting Disks ---'
mkfs.fat -F 32 -n boot $PART1        # (for UEFI systems only)
# mkfs.ext4 -L boot /dev/           # (for MBR systems only)
mkfs.ext4 -L nix $PART2
mkfs.ext4 -L persist $PART3
mkfs.ext4 -L persist-enc /dev/mapper/persist-env
mkswap -L swap $PART5
swapon $PART5

echo '--- Mounting Disks ---'
mount -t tmpfs -o size=1G tmpfs /mnt
mkdir -p /mnt/boot /mnt/nix /mnt/persist /mnt/persist-enc
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot # (for UEFI systems only)
# mount /dev/disk/by-label/boot /mnt/boot # (for MBR systems only)
mount /dev/disk/by-label/nix /mnt/nix
mount /dev/disk/by-label/persist /mnt/persist
mount /dev/disk/by-label/persist-enc /mnt/persist-enc

echo '--- Generating Config ---'
nixos-generate-config --root /mnt
exit

vim /mnt/etc/nixos/configuration.nix
# environment.systemPackages = [ pkgs.vim ]
# nix.settings.experimental-features = [ "nix-command" "flakes" ];

nixos-install
reboot
