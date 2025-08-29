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
    basePackages.enable      = true;
    bootlimit.enable         = true;
    diskusage.enable         = true;
    doas.enable              = true;
    manPages.enable          = true;
    mullvad.enable           = true;
    neovim.enable            = true;
    networkmanager.enable    = true;
    programs.git.enable      = true;
    sessionVariables.enable  = true;
    users.enable             = true;
    zsh.enable               = true;

    bluetooth.enable         = true;
    dwm-enhanced.enable      = true;
    personal-security.enable = true;
    pipewire.enable          = true;

    networking.hostName      = "lenovo";

    networkmanager  = {
      config = "${mp}/persistence/system/system-connections";
    };

    mullvad = {
      configDir = "${mp}/persistence/apps/mullvad/";
    };

    personal-security = {
      gnupgHome        = "${mp}/persistence/apps/gnupg";
      passwordStoreDir = "${mp}/persistence/apps/password-store";
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

      "/home/andrew/.gitconfig"    = bindMount "${mp}/persistence/andrew/gitconfig";
      "/home/andrew/.zshrc"        = bindMount "${mp}/persistence/andrew/zshrc";
      "/home/andrew/.ssh"          = bindMount "${mp}/persistence/andrew/ssh";
      "/root/.ssh"                 = bindMount "${mp}/persistence/root/ssh";
    };

    time.timeZone = "Australia/Sydney";
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    system.stateVersion = "25.05"; 
  };
}
