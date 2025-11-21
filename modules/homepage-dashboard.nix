{ config, pkgs, lib, ... }:

let 
  cfg = config.homepage-dashboard;
in
{
  options.homepage-dashboard = {
    enable = lib.mkEnableOption "audiobookshelf";
  };

  config = lib.mkIf cfg.enable {
    services.homepage-dashboard = {
      enable = true;
      allowedHosts = "homepage";
      widgets = [
        { resources = { cpu = true; disk = "/"; memory = true; }; }
        { search = { provider = "duckduckgo"; target = "_blank"; }; }
      ];
      bookmarks = [ {
        Links = [
          { qBittorrent = [ { abbr = "qb"; href = "http://torrent/"; } ]; }
          { Audiobookshelf = [ { abbr = "abs"; href = "http://abs/"; } ]; }
        ];
      } ];

#      services = [ 
#        {
#          "Summary" = [ 
#            { "Audiobookshelf" = {
#                href = "http://abs/";
#                widget = {
#                  type = "audiobookshelf";
#                  url = "http://localhost:8000";
#                  key = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiIwODg5ZDM2NS0zMDU5LTRmOTAtYjQ1Ny0zNmZjM2RjZTY5MWEiLCJ1c2VybmFtZSI6InJvb3QiLCJpYXQiOjE3NjM2Mjc0MTF9.nSWnpYWN4Q7zHXryv28BsG2qMiXaiMIuRTAtdQ56K2A";
#                };
#              };
#            }
#            { "Torrents" = {
#                href = "http://torrent/";
#                widget = {
#                  type = "qbittorrent";
#                  url = "http://localhost:8080";
#                  username = "admin";
#                  password = "adminadmin";
#                };
#              };
#            } 
#
#          ];
#        }
#      ];

    };
  };
}
