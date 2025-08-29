{ config, lib, pkgs, ... }:

let 
  mp = "/mnt/localPersist";
  settings = "/mnt/localPersist/persistence";
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
      localLuks = {
        device     = "/dev/nvme0n1p5";
        mapperName = "persist-enc";
        mountPoint = "/mnt/localLuks";
      };
    };
  };

  config = {
    bluetooth.enable         = true;
    dwm-enhanced.enable      = true;
    personal-security.enable = true;
    pipewire.enable          = true;

    networking.hostName      = "lenovo";

    users = {
      hashedPasswordFile = "${settings}/andrew/hashedPasswordFile";
    };

    networkmanager  = {
      config = "${settings}/system/system-connections";
    };

    mullvad = {
      configDir = "${settings}/apps/mullvad/";
    };

    personal-security = {
      gnupgHome        = "${settings}/apps/gnupg";
      passwordStoreDir = "${settings}/apps/password-store";
    };

    programs.git = {
      config = {
        safe.directory = [ 
          "${mp}/server-config" 
          "/home/andrew/server-config" 
        ];
        user.name  = [ "andrew" ];
        user.email = [ "andrew.klajman@gmail.com" ];
      };
    };

    fileSystems = {
      "/home/andrew/server-config" = bindMount "${mp}/server-config";
      "/home/andrew/rust"          = bindMount "${mp}/rust";

      "/home/andrew/.gitconfig"    = bindMount "${settings}/andrew/gitconfig";
      "/home/andrew/.zshrc"        = bindMount "${settings}/andrew/zshrc";
      "/home/andrew/.ssh"          = bindMount "${settings}/andrew/ssh";
      "/root/.ssh"                 = bindMount "${settings}/root/ssh";
    };

    time.timeZone = "Australia/Sydney";
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    system.stateVersion = "25.05"; 
  };
}
