{ config, lib, pkgs, ... }:

{


  imports = [ 
    ./hardware-configuration.nix
    ../../modules/default-server.nix
  ];

  config = {
    audiobookshelf.enable          = true;
    environment.systemPackages = [ pkgs.nginx ];
    networking = {
      hostName              = "dell-server";
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [ 80 443 8081 8000];

      };
    };

    i18n.defaultLocale = "en_AU.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_AU.UTF-8";
      LC_IDENTIFICATION = "en_AU.UTF-8";
      LC_MEASUREMENT = "en_AU.UTF-8";
      LC_MONETARY = "en_AU.UTF-8";
      LC_NAME = "en_AU.UTF-8";
      LC_NUMERIC = "en_AU.UTF-8";
      LC_PAPER = "en_AU.UTF-8";
      LC_TELEPHONE = "en_AU.UTF-8";
      LC_TIME = "en_AU.UTF-8";
    };
  
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
  
    services.xserver.xkb = {
      layout = "au";
      variant = "";
    };
  
    services.openssh.enable = true;
    users.users.andrew = {
      isNormalUser = true;
      description = "andrew";
      extraGroups = [ "networkmanager" "wheel" ];
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkquaq2kA7aXURJ0YNaK/E5jmlvrBPTmXoZWABmi0FA andrew@dell" ];  
    };

    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "andrew";
  
    systemd.services."getty@tty1".enable = false;
    systemd.services."autovt@tty1".enable = false;
  
    programs.firefox.enable = true;
  
    programs.git = {
      enable = true;
      config = {
        safe.directory = [ "/home/andrew/server-config" ];
        user = {
          name  = [ "andrew" ];
          email = [ "andrew.klajman@gmail.com" ];
        };
      };
    };

  };
}
