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
          { Gitea = [ { abbr = "git"; href = "http://gitea/"; } ]; }
          { "Free Media Heck Yeah" = [ { abbr = "fmhy"; href = "https://fmhy.net/"; } ]; }
          { "Copyparty" = [ { abbr = "cpy"; href = "http://copyparty/"; } ]; }
        ];
      } ];

    };
  };
}
