{ config, pkgs, lib, ... }:

let
  log             = "/home/andrew/samsunglog";
  rsync_source    = "/mnt/localLuks";
  mnt_point       = "/mnt/ssd";
  crypt_name      = "samsung-portable-ssd";
  crypt_key_file  = "/mnt/localLuks/samsung-portable-ssd.key";
  crypt_device    = "/dev/disk/by-uuid/557f37dc-31e5-4782-ba10-302bc9277d5f";

  umount_samsung = pkgs.writeShellScriptBin "umount_samsung" '' 
    echo "--- $(${pkgs.coreutils}/bin/date) Un Mounting Samsung Portable SSD ---" &>> ${log}
    ${pkgs.rsync}/bin/rsync -av --delete ${rsync_source} ${mnt_point} &>> ${log}
    ${pkgs.systemd}/bin/systemd-umount ${mnt_point} &>> ${log}
    ${pkgs.cryptsetup}/bin/cryptsetup close ${crypt_name} &>> ${log}
    echo "" &>> ${log}
  '';
  mount_samsung = pkgs.writeShellScriptBin "mount_samsung" '' 
    echo "--- $(${pkgs.coreutils}/bin/date) Mounting Samsung Portable SSD ---" &>> ${log}
    ${pkgs.coreutils}/bin/mkdir ${mnt_point} &>> ${log}

    ${pkgs.cryptsetup}/bin/cryptsetup \
      open \
      --key-file ${crypt_key_file} \
      ${crypt_device} \
      ${crypt_name} &>> ${log}

    ${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect \
      /dev/mapper/${crypt_name} \
      ${mnt_point} &>> ${log}

    ${pkgs.rsync}/bin/rsync -av --delete ${rsync_source} ${mnt_point} &>> ${log}
    echo "" &>> ${log}
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
    ];

    services.udev = {
      enable = true;
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="block", ATTRS{serial}=="S6XDNS0W617557K", RUN+="${mount_samsung}/bin/mount_samsung"
      '';
    };
  };
}

