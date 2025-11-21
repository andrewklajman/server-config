{ config, pkgs, lib, copyparty, ... }:

let
  cfg = config.copyparty-server;
in
{
  imports = [
    copyparty.nixosModules.default
  ];

  options.copyparty-server = {
    enable = lib.mkEnableOption "copyparty-server";
  };

  config = lib.mkIf cfg.enable {
    nixpkgs.overlays = [ copyparty.overlays.default ];
    environment.systemPackages = [ pkgs.copyparty ];

    networking.firewall.allowedTCPPorts = [ 3923 ];

    users.groups.media = {
      members = [ "copyparty" ]; # Optional: add existing users to the group
    };

    services.copyparty = {
      enable = true;
      user = "copyparty";
      group = "copyparty";
      settings = {  # directly maps to values in the [global] section of the copyparty
                    # config. see `copyparty --help` for available options
        i = "0.0.0.0";
        p = 3923;
        no-reload = true;
        ignored-flag = false;
      };
    
#      accounts = {
#        main.passwordFile = "/fileserver/config/copyparty/mainPasswordFile.txt";
#      };
#    
#      groups = {
#        main = ["main" ];
#      };
    
      volumes = {
        "/media" = {
          # share the contents of "/srv/copyparty"
          path = "/fileserver/media";
          access = {
            r = "*"; # Read access
            rw = "*"; # Read write access [ "main" ] can be used for groups
            d = "*"; # Read write access [ "main" ] can be used for groups
          };
          flags = { # see `copyparty --help-flags` for available options
            fk = 4; # "fk" enables filekeys (necessary for upget permission) (4 chars long)
            scan = 60; # scan for new files every 60sec
            e2d = true; # volflag "e2d" enables the uploads database
            d2t = true; # "d2t" disables multimedia parsers (in case the uploads are malicious)
            nohash = "\.iso$"; # skips hashing file contents if path matches *.iso
          };
        };
      };

      openFilesLimit = 8192; # you may increase the open file limit for the process
    };
  };
}


