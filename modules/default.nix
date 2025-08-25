{ config, pkgs, lib, localLuks, ... }:

let 
  makeBasicModule =  moduleName: moduleContent: {
    options.${moduleName}.enable = lib.mkEnableOption "${moduleName}";
    config = lib.mkIf config.${moduleName}.enable moduleContent;
  };
in

{
  imports = [
    ./audiobookshelf.nix
    ./desktop-environment
    ./environment
    ./mullvad.nix
    ./personal-security
    ./retroarch.nix
    ./qbittorrent-client.nix
    ./qbittorrent-server.nix
    ./vsftpd-ftp-books.nix

    ( makeBasicModule "calibre" {
        services.udisks2.enable = true;
        services.calibre-server = {
          enable = true;
          libraries = [ "${localLuks.mountPoint}/calibre" ];
        }; 
    } )



  ];
}

