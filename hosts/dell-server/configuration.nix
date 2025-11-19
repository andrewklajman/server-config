{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules
  ];

  config = {

    networking = {
      hostName              = "dell-server";
      firewall = {
        allowedTCPPorts = [ 80 443 ];
        allowedUDPPorts = [ 53 ];
      };
    };

    tailscale-userspace = {
      enable = true;
      configDir = "/root/tailscale";
    };

    services.dnsmasq = {
      enable = true;
      settings = {
        interface = "tailscale0";
        address = [
          "/abs/100.70.63.101"
          "/torrent/100.70.63.101"
        ];
        server = [ "8.8.8.8" "8.8.4.4" ];
      };
    
    };

    services.nginx = {
      enable = true;
      config = ''${builtins.readFile ./config/dell-server-nginx.conf}'';
    };

    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
    };
    services.qbittorrent = {
      enable = true;
      openFirewall = true;
#/root/torrent/config/qBittorrent.conf
    };
    mullvad = {
      enable = true;
      configDir = "/root/mullvad/config";
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
  
    programs.git = {
      enable = true;
      config = {
        safe.directory = [ "/root/server-config" ];
        user = {
          name  = [ "andrew" ];
          email = [ "andrew.klajman@gmail.com" ];
        };
      };
    };

  };
}
