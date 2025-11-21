{ config, pkgs, lib, ... }:

{
  config = {
    copyparty-server.enable = true;

    nix.settings.experimental-features   = [ "nix-command" "flakes" ];

    networking.firewall = {
      allowedTCPPorts = [ 80 443 3000 ];
      allowedUDPPorts = [ 53 ];
    };

    basePackages.enable       = true;
    bootlimit.enable          = true;
    diskusage.enable          = true;
    doas.enable               = true;
    manPages.enable           = true;
    neovim.enable             = true;
    sessionVariables.enable   = true;
    zsh.enable                = true;

    services.openssh.enable = true;
    users.users = {
      andrew = {
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkquaq2kA7aXURJ0YNaK/E5jmlvrBPTmXoZWABmi0FA andrew@dell" ];  
      };
      root = {
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkquaq2kA7aXURJ0YNaK/E5jmlvrBPTmXoZWABmi0FA andrew@dell" ];  
      };
    };

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

#environment.systemPackages = [ pkgs.cloudflared ];

    services.cloudflared = {
      enable = true;
      tunnels = {
        "klajman.xyz" = {
          credentialsFile = "/fileserver/cloudflared/credentialsFile.json";
          default = "http_status:404";
          ingress = {
            "gitea.klajman.xyz" = "http://0.0.0.0:3000";
          };
          warp-routing.enabled = true;
        };
      };
    };


    homepage-dashboard = {
      enable = true;
    };

    tailscale-userspace = {
      enable = true;
      configDir = "/fileserver/config/tailscale";
    };

    services.gitea = {
      enable = true;
      stateDir = "/fileserver/gitea/stateDir";
      settings.session = {
        COOKIE_SECURE = true;
        ROOT_URL = "gitea.klajman.xyz";
        DISABLE_REGISTRATION = true;
      };
    };

    services.dnsmasq = {
      enable = true;
      settings = {
        interface = "tailscale0";
        address = [
          "/abs/100.70.63.101"
          "/torrent/100.70.63.101"
          "/gitea/100.70.63.101"
        ];
        server = [ "8.8.8.8" "8.8.4.4" ];
      };
    };

    services.nginx = {
      enable = true;
      config = ''${builtins.readFile ../../config/dell-server-nginx.conf}'';
    };

    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
    };
    services.qbittorrent = {
      enable = true;
      profileDir = "/fileserver/config/qbittorrent";
    };
    mullvad = {
      enable = true;
      configDir = "/fileserver/config/mullvad";
    };

  };

}

