{ config, lib, pkgs, ... }:

let 
  persist = "/mnt/persist";
  config = "${persist}/config";
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

  config = {
    basePackages.enable     = true;
    bootlimit.enable         = true;
    diskusage.enable         = true;
    doas.enable             = true;
    manPages.enable          = true;
    mullvad.enable          = true;
    neovim.enable           = true;
    networkmanager.enable   = true;
    programs.git.enable     = true;
    sessionVariables.enable = true;
    users.enable            = true;
    zsh.enable              = true;

    dwm-basic.enable        = true;
    openssh.enable          = true;

    networking.hostName     = "system76";

    networkmanager  = {
      config = "${config}/system-connections";
    };

    openssh = {
      sshKey = {
        device = "${config}/ssh-andrew";
        mountPoint = "/home/andrew/.ssh";
      };
      authKeyFile = {
        device = "${config}/ssh-andrew-authorized-keys";
        mountPoint = "/home/andrew/.ssh/authorized_keys";
      };
    };

    mullvad = {
      configDir = "${config}/mullvad";
    };

    programs.git = {
      config = {
        safe.directory = [ "${persist}/server-config" ];
        user.name  =     [ "andrew" ];
        user.email =     [ "andrew.klajman@gmail.com" ];
      };
    };

    time.timeZone = "Australia/Sydney";
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda"; 
    system.stateVersion = "25.05"; 
  };
}

