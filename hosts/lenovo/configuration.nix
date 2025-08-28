{ config, lib, pkgs, localPersist, ... }:

let 
  mp = config.consts.localPersist.mountPoint;
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

  options.consts = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
    default = {
      localPersist = {
        device     = "/dev/disk/by-uuid/9e831367-26eb-4ece-a7a5-666d46034160";
        mountPoint = "/mnt/localPersist";
      };
      localLuks = {
        device     = "/dev/nvme0n1p5";
        mapperName = "persist-enc";
        mountPoint = "/mnt/localLuks";
      };
    };
  };

  config = {
    environment.enable        = true;

    calibre.enable            = true;
    dwm-enhanced.enable       = true;

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
  };
}
