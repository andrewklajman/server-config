echo '--- Setting Variables ---'
LUKS_PASS=""
USER_PASS=""

echo "LUKS Password: $LUKS_PASS"
echo "User Password: $USER_PASS"

DISK="/dev/nvme0n1"
PART1="/dev/nvme0n1p1"
PART2="/dev/nvme0n1p2"
PART3="/dev/nvme0n1p3"
PART4="/dev/nvme0n1p4"
PART5="/dev/nvme0n1p5"

echo '--- Partitioning (UEFI) ---'
parted $DISK -- mklabel gpt
parted $DISK -- mkpart ESP          fat32        1MB 512MB
parted $DISK -- mkpart nix          ext4       512MB 100GB
parted $DISK -- mkpart localPersist ext4       100GB 110GB
parted $DISK -- mkpart localLuks    ext4       110GB -10GB
parted $DISK -- mkpart swap         linux-swap -10GB  100%
parted $DISK -- set 1 esp on

echo '--- Disk Encryption ---'
echo $LUKS_PASS | cryptsetup -q luksFormat $PART4
echo $LUKS_PASS | cryptsetup -q open $PART4 localLuks

echo '--- Formatting Disks ---'
mkfs.fat -F 32 -n boot $PART1        # (for UEFI systems only)
# mkfs.ext4 -L boot /dev/           # (for MBR systems only)
mkfs.ext4 -q -L nix $PART2
mkfs.ext4 -q -L localPersist $PART3
mkfs.ext4 -q -L localLuks /dev/mapper/localLuks
mkswap -q -L swap $PART5
swapon $PART5

echo '--- Mounting Disks ---'
mount -t tmpfs -o size=1G tmpfs /mnt
mkdir -p /mnt/boot /mnt/nix /mnt/mnt/localPersist /mnt/mnt/localLuks
mount -o umask=077 /dev/disk/by-label/boot /mnt/boot # (for UEFI systems only)
# mount /dev/disk/by-label/boot /mnt/boot # (for MBR systems only)
mount /dev/disk/by-label/nix /mnt/nix
mount /dev/disk/by-label/localPersist /mnt/mnt/localPersist
mount /dev/disk/by-label/localLuks /mnt/mnt/localLuks

echo '--- Generating and Adjust Config ---'
nixos-generate-config --root /mnt
sed -i '16 i environment.systemPackages = with pkgs; [ vim git ];' /mnt/etc/nixos/configuration.nix
sed -i '16 i nix.settings.experimental-features = [ "nix-command" "flakes" ];' /mnt/etc/nixos/configuration.nix
sed -i '16 i users.users.root.initialPassword = "pass";' /mnt/etc/nixos/configuration.nix
sed -i '7 i fileSystems."/mnt/localPersist".neededForBoot = true;' /mnt/etc/nixos/hardware-configuration.nix

echo "CHECK SYSTEM BEFORE PROCEEDING"
read
nvim /mnt/etc/nixos/configuration.nix
nvim /mnt/etc/nixos/hardware-configuration.nix

echo "DO YOU WANT TO PROCEED WITH INSTALLATION?"
read

echo '--- Installation ---'
nixos-install

echo '--- File Backup ---'
mkdir /mnt/mnt/localPersist/original_config
cp /mnt/etc/nixos/* /mnt/mnt/localPersist/original_config
cd /mnt/mnt/localPersist
git clone https://www.github.com/andrewklajman/server-config

echo '--- Miscellaneous ---'
mkdir -p /mnt/mnt/localPersist/persistence/root/ssh
ssh-keygen -N '' -f /mnt/mnt/localPersist/persistence/root/ssh
mkdir -p /mnt/mnt/localPersist/persistence/andrew/ssh
ssh-keygen -N '' -f /mnt/mnt/localPersist/persistence/andrew/ssh
chown -R andrew:users /mnt/mnt/localPersist/persistence/andrew/ssh

echo "$USER_PASS" | mkpasswd -s > /mnt/localPersist/andrew/hashedPasswordFile
cp /etc/NetworkManager/system-connections /mnt/localPersist/persistence/system
gpg --import ./server-config/scripts/NixosInstallation/gpg_public.export

echo '--- Checklist ---'
echo ' * Add SSH to github'

