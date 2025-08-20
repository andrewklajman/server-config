{ config, pkgs, lib, localLuks, ... }:

let 
  mp = localLuks.mountPoint;
in
{
  options.torrent.enable = lib.mkEnableOption "torrent";

  config = lib.mkIf config.torrent.enable {

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

#    environment.systemPackages = [
#      pkgs.qbittorrent
#      torrent
#    ];

  };

}

