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

    users.users.root.initialPassword = "pass";
    users.users.andrew = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      initialPassword = "pass";
    };
    programs.neovim.enable = true;
    programs.git = {
      enable = true;
      config = {
        user.name  = "andrew";
        user.email = "andrew";
      };
    };

    boot.loader.systemd-boot.configurationLimit = 10;
    nix.settings.auto-optimise-store = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
    time.timeZone = "Australia/Sydney";
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

#    calibre.enable            = true;
#    dwm-basic.enable          = true;

#    audiobookshelf.enable     = false; 
#    qbittorrent-client.enable = true;
#    personal-security = {
#      enable                  = true;
#      gnupgHome               = "${mp}/persistence/apps/gnupg";
#      passwordStoreDir        = "${mp}/persistence/apps/password-store";
#    };
#    mullvad = { 
#      enable    = true; 
#      configDir = "${mp}/persistence/apps/mullvad/";
#    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    system.stateVersion = "25.05";
  };
}
