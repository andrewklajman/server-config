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
    # ./hardware-configuration.lenovo.nix
    ./hardware-configuration.system76.nix
    ../../modules
  ];

#  options.consts = lib.mkOption {
#    type = lib.types.attrs;
#    readOnly = true;
#    default = {
#      localPersist = {
#        device     = "/dev/disk/by-uuid/9e831367-26eb-4ece-a7a5-666d46034160";
#        mountPoint = "/mnt/localPersist";
#      };
#      localLuks = {
#        device     = "/dev/nvme0n1p5";
#        mapperName = "persist-enc";
#        mountPoint = "/mnt/localLuks";
#      };
#    };
#  };

  config = {
  # Gnome
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # NeoVim
  programs.neovim.enable = true;

  # Users
    users.users.root.initialPassword = "pass";
    users.users.andrew = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      initialPassword = "pass";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIO1xYDuifkxPNSGcA6CvsNqHRgzEi8Uxpp2qrVck3w62 andrew@nixos"
      ];
    };

  # Timezone
    time.timeZone = "Australia/Sydney";
  
  # Reducing disk space usage
    boot.loader.systemd-boot.configurationLimit = 10;
    nix.settings.auto-optimise-store = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  
  # Git
    programs.git = {
      enable = true;
      config = {
        user.name = [ "andrew" ];
        user.email = [ "andrew.klajman@gmail.com" ];
      };
    };
  

#     environment.enable        = true;
# 
#     calibre.enable            = true;
#     dwm-enhanced.enable       = true;
# 
#     audiobookshelf.enable     = false; 
#     qbittorrent-client.enable = true;
#     personal-security = {
#       enable                  = true;
#       gnupgHome               = "${mp}/persistence/apps/gnupg";
#       passwordStoreDir        = "${mp}/persistence/apps/password-store";
#     };
#     mullvad = { 
#       enable    = true; 
#       configDir = "${mp}/persistence/apps/mullvad/";
#     };
# 
#     fileSystems = {
#       "/home/andrew/server-config" = bindMount "${mp}/server-config";
#       "/home/andrew/rust"          = bindMount "${mp}/rust";
# 
#       "/home/andrew/.gitconfig"    = bindMount "${mp}/persistence/andrew/gitconfig";
#       "/home/andrew/.zshrc"        = bindMount "${mp}/persistence/andrew/zshrc";
#       "/home/andrew/.ssh"          = bindMount "${mp}/persistence/andrew/ssh";
#       "/root/.ssh"                 = bindMount "${mp}/persistence/root/ssh";
#       "/etc/NetworkManager/system-connections" = bindMount "${mp}/persistence/system/system-connections";
#     };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    system.stateVersion = "25.05";
  };
}
