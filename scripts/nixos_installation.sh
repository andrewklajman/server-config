# # Partition (MBR)
# parted /dev/ -- mklabel msdos
# parted /dev/ -- mkpart primary 1MB -8GB
# parted /dev/ -- mkpart primary linux-swap -8GB 100%

echo '--- Setting Variables ---'
LUKS_PASS=""
DISK="/dev/nvme0n1"
PART1="/dev/nvme0n1p1"
PART2="/dev/nvme0n1p2"
PART3="/dev/nvme0n1p3"
PART4="/dev/nvme0n1p4"
PART5="/dev/nvme0n1p5"

echo '--- Partitioning (UEFI) ---'
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP fat32 1MB 512MB
parted $DISK -- mkpart nix ext4 512MB 100GB
parted $DISK -- mkpart persist ext4 100GB 150GB
parted $DISK -- mkpart persist-enc ext4 150GB 200GB
parted $DISK -- mkpart swap linux-swap 200GB 210GB
parted $DISK -- set 1 esp on

echo '--- Disk Encryption ---'
echo $LUKS_PASS | cryptsetup -q luksFormat $PART4
echo $LUKS_PASS | cryptsetup -q open $PART4 persist-enc

echo '--- Formatting Disks ---'
mkfs.fat -F 32 -n boot $PART1        # (for UEFI systems only)
# mkfs.ext4 -L boot /dev/           # (for MBR systems only)
mkfs.ext4 -L nix $PART2
mkfs.ext4 -L persist $PART3
mkfs.ext4 -L persist-enc /dev/mapper/persist-enc
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
sed '16 i environment.systemPackages = with pkgs; [ vim git ];' /mnt/etc/nixos/configuration.nix
sed '16 i nix.settings.experimental-features = [ "nix-command" "flakes" ];' /mnt/etc/nixos/configuration.nix
sed '16 i users.users.root.initialPassword = "pass";' /mnt/etc/nixos/configuration.nix

nixos-install

