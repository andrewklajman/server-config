{ config, pkgs, lib, localLuks, ... }:

let 
  mp = localLuks.mountPoint;
in
{
  options.qbittorrent-client.enable = lib.mkEnableOption "qbittorrent-client";

  config = lib.mkIf config.qbittorrent-client.enable {

    environment.systemPackages = [
      ( pkgs.symlinkJoin {
        name = lib.getName pkgs.qbittorrent;
        paths = [ pkgs.qbittorrent ];
        nativeBuildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/qbittorrent \
            --add-flag --profile=${mp}/torrent/profile 
        '';
      } ) 
    ];

  };

}

