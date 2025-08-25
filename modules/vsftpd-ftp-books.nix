# Notes
#  - Mullvad may interfere

{ config, pkgs, lib, ... }:

let 
  cfg = config.vsftpd-ftp-books;
in

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
    serviceTrigger = lib.mkOption {
      type = lib.types.str;
      default = "mnt-localLuks.service";
    };
  };
  
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 20 21 ];
    networking.firewall.allowedTCPPortRanges = [ cfg.pasvPorts ];

    fileSystems."/home/books" =  {
      device = cfg.booksFolder;
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
        pasv_min_port=${toString cfg.pasvPorts.from}
        pasv_max_port=${toString cfg.pasvPorts.to}
      '';
    };

    # https://doc.owncloud.com/ocis/next/deployment/tips/useful_mount_tip.html
    systemd.services.vsftpd = {
      description = lib.mkForce "Vsftpd Server (After localLuks mount)";
      requires =             [ "${cfg.serviceTrigger}" ];
      after    =             [ "${cfg.serviceTrigger}" ];
      wantedBy = lib.mkForce [ "${cfg.serviceTrigger}" ];
    };

  };
}

