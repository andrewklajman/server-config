{ config, pkgs, lib, localLuks, ... }:

let
  cfg = config.networkmanager;
in
{
  options.networkmanager = {
    enable = lib.mkEnableOption "NetworkManagerEnable";
    config = lib.mkOption { type = lib.types.str; };
  };
  
  config = lib.mkIf cfg.enable {
    networking.networkmanager.enable = true; 
    fileSystems."/etc/NetworkManager/system-connections" = {
      device = "${cfg.config}";
      options = [ "bind" ];
    };
  };

}

