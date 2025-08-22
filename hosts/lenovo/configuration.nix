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

  calibre.enable            = true;
  desktop-manager           = "dwm";

  audiobookshelf.enable     = false; 
  qbittorrent-client.enable = true;
  personal-security = {
    enable                  = true;
    gnupgHome               = "${mp}/persistence/apps/gnupg";
    passwordStoreDir        = "${mp}/persistence/apps/password-store";
  };
  mullvad = { 
    enable    = true; 
    configDir = "${mp}/persistence/apps/mullvad/";
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
