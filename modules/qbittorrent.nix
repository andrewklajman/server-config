{ config, pkgs, lib, ... }:

let
  torrent = pkgs.writeShellScriptBin 
          "torrent" 
          '' qbittorrent --profile="/persist/persist-encrypted/torrent/profile" '';
in
{
  options.qbittorrent.enable = lib.mkEnableOption "qbittorrent";

  config = lib.mkIf config.qbittorrent.enable {
    environment.systemPackages = with pkgs; [ 
      qbittorrent 
      torrent
    ];
  };
}

