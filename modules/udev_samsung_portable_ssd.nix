{ config, pkgs, lib, ... }:

let
  luks            = config.consts.localLuks.mountPoint;
  log             = "${luks}/Documents/open_notes/notes";
  rsync_source    = "${luks}";
  mnt_point       = "/mnt/ssd";
  crypt_name      = "samsung-portable-ssd";
  crypt_key_file  = "${luks}/samsung-portable-ssd.key";
  crypt_device    = "/dev/disk/by-uuid/557f37dc-31e5-4782-ba10-302bc9277d5f";

  umount_samsung = pkgs.writeShellScriptBin "umount_samsung" '' 
    LOG="$(${pkgs.coreutils}/bin/date +${log}/%Y%m%d-%H%M.md)"
    
    if [ ! -f $LOG ]; then
      echo "logs/samsung" &>> $LOG
      echo "++++" &>> $LOG
      echo "" &>> $LOG
    fi

    echo "# Umounting Samsung Portable SSD" &>> $LOG
    echo "" &>> $LOG
    
    ${pkgs.rsync}/bin/rsync -av --delete ${rsync_source} ${mnt_point} &>> $LOG
    echo "" &>> $LOG
    ${pkgs.systemd}/bin/systemd-umount ${mnt_point} &>> $LOG
    echo "" &>> $LOG
    ${pkgs.cryptsetup}/bin/cryptsetup close ${crypt_name} &>> $LOG
    echo "" &>> $LOG

    echo " " &>> $LOG
  '';

  mount_samsung = pkgs.writeShellScriptBin "mount_samsung" '' 
    sleep 1
    LOG="$(${pkgs.coreutils}/bin/date +${log}/%Y%m%d-%H%M.md)"

    if [ ! -f $LOG ]; then
      echo "logs/samsung" &>> $LOG
      echo "++++" &>> $LOG
      echo "" &>> $LOG
    fi

    echo "# Mounting Samsung Portable SSD" &>> $LOG
    echo "" &>> $LOG

    ${pkgs.coreutils}/bin/mkdir ${mnt_point} &>> $LOG
    echo "" &>> $LOG

    ${pkgs.cryptsetup}/bin/cryptsetup \
      open \
      --key-file ${crypt_key_file} \
      ${crypt_device} \
      ${crypt_name} &>> $LOG
    echo "" &>> $LOG

    ${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect \
      /dev/mapper/${crypt_name} \
      ${mnt_point} &>> $LOG
    echo "" &>> $LOG

    ${pkgs.rsync}/bin/rsync -av --delete ${rsync_source} ${mnt_point} &>> ${log}
    echo "" &>> $LOG

    echo "" &>> $LOG
  '';
in 
{
  options.udev-samsung-portable-ssd.enable = lib.mkEnableOption "zsh";
  config = lib.mkIf config.udev-samsung-portable-ssd.enable  {
    environment.systemPackages = with pkgs; [ 
      umount_samsung
      mount_samsung
      mount
      rsync
      coreutils
    ];

    services.udev = {
      enable = true;
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="block", ATTRS{serial}=="S6XDNS0W617557K", RUN+="${mount_samsung}/bin/mount_samsung"
      '';
    };
  };
}

