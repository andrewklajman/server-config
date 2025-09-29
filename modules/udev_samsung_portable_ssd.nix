{ config, pkgs, lib, ... }:

let
      #${pkgs.mktemp}/bin/mktemp "test.XXXXXX"
  mount_samsung = pkgs.writeShellScriptBin "mount_samsung" '' 
      LOG="$(${pkgs.mktemp}/bin/mktemp mount_samsung.XXXXXX)"
      ${pkgs.coreutils}/bin/mkdir /mnt/ssd
      ${pkgs.systemd}/bin/systemd-mount --no-block --automount=yes --collect \
        /dev/disk/by-uuid/6be4ce06-2537-4304-b284-a54cf638c341 \
        /mnt/ssd &>> $LOG
  '';
in 
{
  options.udev-samsung-portable-ssd.enable = lib.mkEnableOption "zsh";
  config = lib.mkIf config.udev-samsung-portable-ssd.enable  {
    environment.systemPackages = with pkgs; [ 
      mount_samsung
      mount
    ];

    services.udev = {
      enable = true;
      extraRules = ''
        ACTION=="add", SUBSYSTEM=="block", ATTRS{serial}=="S6XDNS0W617557K", RUN+="${mount_samsung}/bin/mount_samsung"
      '';
    };
  };
}

