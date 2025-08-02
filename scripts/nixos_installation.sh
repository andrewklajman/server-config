# # Partition (MBR)
# parted /dev/sda -- mklabel msdos
# parted /dev/sda -- mkpart primary 1MB -8GB
# parted /dev/sda -- mkpart primary linux-swap -8GB 100%

# Partition (UEFI)
parted /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart ESP fat32 1MB 512MB
parted /dev/sda -- mkpart nix ext4 512MB 100GB
parted /dev/sda -- mkpart persist ext4 100GB 150GB
parted /dev/sda -- mkpart persist-enc ext4 150GB 220GB
parted /dev/sda -- mkpart swap linux-swap 220GB 100%
parted /dev/sda -- set 5 esp on

# Installation
cryptsetup luksFormat /dev/sda4
cryptsetup open /dev/sda4 persist-enc
mkdir -p /mnt/boot /mnt/nix /mnt/persist /mnt/persist-enc

mkfs.fat -F 32 -n boot /dev/sda1        # (for UEFI systems only)
# mkfs.ext4 -L boot /dev/sda1           # (for MBR systems only)
mkfs.ext4 -L nix /dev/sda2
mkfs.ext4 -L persist /dev/sda3
mkfs.ext4 -L persist-enc /dev/mapper/persist-env
mkswap -L swap /dev/sda5
swapon /dev/sda5

mount -t tmpfs -o size=1G /mnt
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot # (for UEFI systems only)
# mount /dev/disk/by-label/boot /mnt/boot # (for MBR systems only)
mount /dev/disk/by-label/nix /mnt/nix
mount /dev/disk/by-label/persist /mnt/persist
mount /dev/disk/by-label/persist-enc /mnt/persist-enc

nixos-generate-config --root /mnt
vim /mnt/etc/nixos/configuration.nix
# environment.systemPackages = [ pkgs.vim ]
# nix.settings.experimental-features = [ "nix-command" "flakes" ];

nixos-install
reboot
