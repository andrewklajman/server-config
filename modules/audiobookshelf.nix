{ config, pkgs, lib, ... }:

{
  options.audiobookshelf.enable = lib.mkEnableOption "audiobookshelf";

  config = lib.mkIf config.audiobookshelf.enable {
    networking.firewall.allowedTCPPorts = [ 8000 ];
    services.audiobookshelf = {
      enable = true;
      host = "0.0.0.0";
    };
  };

}
