# Notes
#  - Mullvad may interfere

{ config, pkgs, lib, ... }:

{
  options.vsftpd-ftp-books = {
    enable = lib.mkEnableOption "vsftpd-ftp-books";
    pasvPorts = lib.mkOption {
      type = lib.types.attrs;
      default = { from = 51000; to = 51999; };
    };
    booksFolder = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/localLuks/books";
    };
  };
  
  config = lib.mkIf config.vsftpd-ftp-books.enable {
    networking.firewall.allowedTCPPorts = [ 20 21 ];
    networking.firewall.allowedTCPPortRanges = [ config.vsftpd-ftp-books.pasvPorts ];

    fileSystems."/home/books" =  {
      device = config.vsftpd-ftp-books.booksFolder;
      options = [ "bind" ];
    };
  
    users.users.books = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      initialPassword = "pass";
    };
  
    services.vsftpd = {
      enable = true;
      writeEnable = true;
      localUsers = true;
      userlist = [ "books" ];
      userlistEnable = true;
      extraConfig = ''
        pasv_enable=YES
        pasv_min_port=${toString config.vsftpd-ftp-books.pasvPorts.from}
        pasv_max_port=${toString config.vsftpd-ftp-books.pasvPorts.to}
      '';
    };

    # https://doc.owncloud.com/ocis/next/deployment/tips/useful_mount_tip.html
    systemd.services.vsftpd = {
      description = lib.mkForce "Vsftpd Server (After localLuks mount)";
      requires = [ "mnt-localLuks.mount" ];
      after    = [ "mnt-localLuks.mount" ];
      unitConfig = {
        RequiresMountsFor = "/mnt/localLuks";
      };
    };

  };
}

