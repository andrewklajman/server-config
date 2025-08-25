{ config, pkgs, lib, localLuks, ... }:

let 
  makeBasicModule =  moduleName: moduleContent: {
    options.${moduleName}.enable = lib.mkEnableOption "${moduleName}";
    config = lib.mkIf config.${moduleName}.enable moduleContent;
  };
in

{
  imports = [
    ./desktop-environment
    ./environment
    ./mullvad.nix
    ./personal-security
    ./retroarch.nix
    ./qbittorrent-client.nix
    ./qbittorrent-server.nix
    ./vsftpd-ftp-books.nix

    ( makeBasicModule "audiobookshelf" { 
        networking.firewall.allowedTCPPorts = [ 8000 ];
        services.audiobookshelf = {
          enable = true;
          host = "0.0.0.0";
        };
    } )

    ( makeBasicModule "calibre" {
        services.udisks2.enable = true;
        services.calibre-server = {
          enable = true;
          libraries = [ "${localLuks.mountPoint}/calibre" ];
        }; 
    } )



  ];
}

