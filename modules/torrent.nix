{ config, pkgs, lib, localLuks, ... }:

let 
  mp = localLuks.mountPoint;
  torrent = pkgs.writeShellScriptBin "torrent" ''
    qbittorrent --profile=${mp}/torrent/profile
  '';
in
{
  options.torrent.enable = lib.mkEnableOption "torrent";

  config = lib.mkIf config.torrent.enable {
    environment.systemPackages = [
      pkgs.qbittorrent
      torrent
    ];

  };

}

