{ config, pkgs, lib, ... }:

let 
  cfg = config.qbittorrent-client;
  luks = config.consts.localLuks.mountPoint;
in
{
  options.qbittorrent-client = {
    enable = lib.mkEnableOption "qbittorrent-client";
    profile = lib.mkOption {
      type = lib.types.str;
      default = "${luks}/torrent/profile";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      ( pkgs.symlinkJoin {
        name = lib.getName pkgs.qbittorrent;
        paths = [ pkgs.qbittorrent ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/qbittorrent \
            --add-flag --profile=${luks}
        '';
      } ) 
    ];

  };

}

