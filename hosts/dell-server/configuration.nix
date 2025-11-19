{ config, lib, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules/default-server.nix

#    ../../modules/dell-server/cloudflare-abs-sertup.nix
  ];

  config = {
    networking = {
      hostName                 = "dell-server";
      firewall.allowedTCPPorts = [ 80 443 ];
      networkmanager.enable = true; 
    };
#     cloudflare-abs.enable = true;

#    environment.systemPackages = [ pkgs.dnsmasq ];
#    services.tailscale = {
#        enable = true;
#        authKeyFile = "/root/tailscale.authkeyfile";
#      };

#    services.dnsmasq = {
#      enable = true;
#      settings = {
#        #interface = "wlp0s20f3";
#        interface = "tailscale0";
#        address = [ 
#          "/abs/100.70.63.101"
#          "/torrent/100.70.63.101"
#        ];
#        server = [ "8.8.8.8" "8.8.4.4" ];
#      };
#
#    };
#    services.nginx = {
#        enable = true;
#        config = ''
#events { worker_connections  1024; }
#
#http {
#  server { 
#    listen 80; listen [::]:80; 
#    server_name abs;
#      location / { 
#        proxy_pass http://127.0.0.1:8000;
#        proxy_http_version  1.1;
#        proxy_cache_bypass  $http_upgrade;
#        proxy_set_header Upgrade           $http_upgrade;
#        proxy_set_header Connection        "upgrade";
#        proxy_read_timeout                 86400;
#        proxy_set_header Host              $host;
#        proxy_set_header X-Real-IP         $remote_addr;
#        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
#        proxy_set_header X-Forwarded-Proto $scheme;
#        proxy_set_header X-Forwarded-Host  $host;
#        proxy_set_header X-Forwarded-Port  $server_port;
#      }
#  }
#
#  server { 
#    listen 80; listen [::]:80; 
#    server_name torrent;
#      location / { 
#        proxy_pass http://127.0.0.1:8080;
#        proxy_http_version  1.1;
#        proxy_cache_bypass  $http_upgrade;
#        proxy_set_header Upgrade           $http_upgrade;
#        proxy_set_header Connection        "upgrade";
#        proxy_read_timeout                 86400;
#        proxy_set_header Host              $host;
#        proxy_set_header X-Real-IP         $remote_addr;
#        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
#        proxy_set_header X-Forwarded-Proto $scheme;
#        proxy_set_header X-Forwarded-Host  $host;
#        proxy_set_header X-Forwarded-Port  $server_port;
#      }
#  }
#}
#'';
#    };
#
#    services.audiobookshelf = {
#      enable = true;
#      host = "0.0.0.0";
#    };
#    services.qbittorrent = {
#      enable = true;
#      openFirewall = true;
##/root/torrent/config/qBittorrent.conf
#    };
#    mullvad = {
#      enable = true;
#      configDir = "/root/mullvad/config";
#    };






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
        safe.directory = [ "/root/server-config" ];
        user = {
          name  = [ "andrew" ];
          email = [ "andrew.klajman@gmail.com" ];
        };
      };
    };

  };
}
