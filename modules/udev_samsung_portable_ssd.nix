{ config, pkgs, lib, ... }:

let
  luks            = config.consts.localLuks.mountPoint;
  log             = "${luks}/critical/open_notes/notes";
  rsync_source    = "${luks}";
  mnt_point       = "/mnt/ssd";
  crypt_name      = "samsung-portable-ssd";
  crypt_key_file  = "${luks}/critical/samsung-portable-ssd.key";
  crypt_device    = "/dev/disk/by-uuid/557f37dc-31e5-4782-ba10-302bc9277d5f";

  umount_samsung = pkgs.writeShellScriptBin "umount_samsung" '' 
    LOG="$(${pkgs.coreutils}/bin/date +${log}/%Y%m%d-%H%M%S.md)"
    echo $LOG
    
    if [ ! -f $LOG ]; then
      echo "logs/samsung" 2>&1 | tee --append $LOG
      echo "++++" 2>&1 | tee --append $LOG
    fi

    echo -e "\n\n# $(date '+%Y%m%d %H%M') Un Mounting Samsung Portable SSD" 2>&1 | tee --append $LOG

    if [ ! -d ${mnt_point} ]; then
      echo -e "\nAborting: There is no ${mnt_point}" 2>&1 | tee --append $LOG
      exit
    fi
    
    #echo -e "\n\n## IF ${mnt_point} Mounted THEN rsync -av --delete ${rsync_source} ${mnt_point}\n" 2>&1 | tee --append $LOG
    mount -v | grep ${mnt_point} && ${pkgs.rsync}/bin/rsync -av --delete ${luks}/critical ${mnt_point} 2>&1 | tee --append $LOG
    mount -v | grep ${mnt_point} && ${pkgs.rsync}/bin/rsync -av --delete ${luks}/Documents ${mnt_point} 2>&1 | tee --append $LOG

    echo -e "\n\n## systemd-umount ${mnt_point}\n" 2>&1 | tee --append $LOG
    ${pkgs.systemd}/bin/systemd-umount ${mnt_point} 2>&1 | tee --append $LOG

    echo -e "\n\n## cryptsetup close ${crypt_name}\n" 2>&1 | tee --append $LOG
    ${pkgs.cryptsetup}/bin/cryptsetup close ${crypt_name} 2>&1 | tee --append $LOG

    echo -e "\n\n## rmdir ${mnt_point}\n"
    rmdir ${mnt_point} 2>&1 | tee --append $LOG

    mount -v | grep ${mnt_point} || ${pkgs.doas}/bin/doas -u andrew ${pkgs.libnotify}/bin/notify-send "Samsung SSD Removed"
  '';

  mount_samsung = pkgs.writeShellScriptBin "mount_samsung" '' 
    LOG="$(${pkgs.coreutils}/bin/date +${log}/%Y%m%d-%H%M%S.md)"

    if [ ! -f $LOG ]; then
      echo "logs/samsung" 2>&1 | tee --append $LOG
      echo "++++" 2>&1 | tee --append $LOG
    fi

    echo -e "\n\n# $(date '+%Y%m%d %H%M') Mounting Samsung Portable SSD\n" 2>&1 | tee --append $LOG

    echo -e "\n\n## mkdir ${mnt_point}\n" 2>&1 | tee --append $LOG
    [ ! -d ${mnt_point} ] && ${pkgs.coreutils}/bin/mkdir ${mnt_point} 2>&1 | tee --append $LOG

    echo -e "\n\n## cryptsetup open --key-flie ${crypt_key_file} ${crypt_device} ${crypt_name}\n" 2>&1 | tee --append $LOG
    ${pkgs.cryptsetup}/bin/cryptsetup \
      open \
      --key-file ${crypt_key_file} \
      ${crypt_device} \
      ${crypt_name} 2>&1 | tee --append $LOG

    echo -e "\n\n## systemd-mount /dev/mapper/${crypt_name} ${mnt_point}\n" 2>&1 | tee --append $LOG
    ${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect \
      /dev/mapper/${crypt_name} \
      ${mnt_point} 2>&1 | tee --append $LOG

    echo -e "\n\n## rsync -av --delete ${rsync_source} ${mnt_point}\n" 2>&1 | tee --append $LOG
    mount -v | grep ${mnt_point} && ${pkgs.rsync}/bin/rsync -av --delete ${luks}/critical ${mnt_point} 2>&1 | tee --append $LOG
    mount -v | grep ${mnt_point} && ${pkgs.rsync}/bin/rsync -av --delete ${luks}/Documents ${mnt_point} 2>&1 | tee --append $LOG

    mount -v | grep ${mnt_point} && ${pkgs.doas}/bin/doas -u andrew ${pkgs.libnotify}/bin/notify-send "Samsung SSD Mounted"
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

