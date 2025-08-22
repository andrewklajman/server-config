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
    gnupgHome               = "${localPersist.mountPoint}/persistence/apps/gnupg";
    passwordStoreDir        = "${localPersist.mountPoint}/persistence/apps/password-store";
  };
  mullvad = { 
    enable = true; 
    mullvadSettingsDir      = "${localPersist.mountPoint}/persistence/apps/mullvad/MULLVAD_SETTINGS_DIR/";
    mullvadCacheDir         = "${localPersist.mountPoint}/persistence/apps/mullvad/MULLVAD_CACHE_DIR/";
  };

  fileSystems = {
    "/home/andrew/server-config" = bindMount "${localPersist.mountPoint}/server-config";
    "/home/andrew/rust"          = bindMount "${localPersist.mountPoint}/rust";

    "/home/andrew/.gitconfig"    = bindMount "${localPersist.mountPoint}/persistence/andrew/gitconfig";
    "/home/andrew/.zshrc"        = bindMount "${localPersist.mountPoint}/persistence/andrew/zshrc";
    "/home/andrew/.ssh"          = bindMount "${localPersist.mountPoint}/persistence/andrew/ssh";
    "/root/.ssh"                 = bindMount "${localPersist.mountPoint}/persistence/root/ssh";
    "/etc/NetworkManager/system-connections" = bindMount "${localPersist.mountPoint}/persistence/system/system-connections";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05";

}
