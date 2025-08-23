{ config, lib, pkgs, localPersist, ... }:

let 
  mp = localPersist.mountPoint;
  bindMount = device: {
    inherit device;
    options = [ "bind" ];
  };
in

{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules
  ];

# https://www.digitalocean.com/community/tutorials/how-to-set-up-vsftpd-for-a-user-s-directory-on-ubuntu-20-04
  networking.firewall = { allowedTCPPorts = [ 20 21 ]; };
  services.vsftpd = {
    enable = true;
    # anonymousUser = true;
    # anonymousUserHome = "/home/andrew";
    # anonymousUserNoPassword = true;
    # anonymousMkdirEnable = true;
    writeEnable = true;
    localUsers = true;
    userlist = [ "andrew" ];
    userlistEnable = true;
  };

  services.vsftpd.extraConfig = ''
    pasv_enable=Yes
    pasv_min_port=51000
    pasv_max_port=51999
  '';
  networking.firewall.allowedTCPPortRanges = [ { from = 51000; to = 51999; } ];


#  environment.systemPackages = [ pkgs.vsftpd ];
#  networking.firewall.allowedTCPPortRanges = [
#    {
#      from = 40000;
#      to = 50000;
#    }
#  ];


  calibre.enable            = false;
  desktop-manager           = "dwm";

  audiobookshelf.enable     = false; 
  qbittorrent-client.enable = false;
  personal-security = {
    enable                  = false;
    gnupgHome               = "${mp}/persistence/apps/gnupg";
    passwordStoreDir        = "${mp}/persistence/apps/password-store";
  };
  mullvad = { 
    enable                  = true; 
    configDir               = "${mp}/persistence/apps/mullvad/";
  };

  fileSystems = {
    "/home/andrew/server-config" = bindMount "${mp}/server-config";
    "/home/andrew/rust"          = bindMount "${mp}/rust";

    "/home/andrew/.gitconfig"    = bindMount "${mp}/persistence/andrew/gitconfig";
    "/home/andrew/.zshrc"        = bindMount "${mp}/persistence/andrew/zshrc";
    "/home/andrew/.ssh"          = bindMount "${mp}/persistence/andrew/ssh";
    "/root/.ssh"                 = bindMount "${mp}/persistence/root/ssh";
    "/etc/NetworkManager/system-connections" = bindMount "${mp}/persistence/system/system-connections";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05";

}

