{ config, pkgs, lib, localLuks, ... }:

let
  cfg = config.audiobookshelf;
in
{
  options.audiobookshelf = {
    enable = lib.mkEnableOption "audiobookshelf";
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "${localLuks.mountPoint}/audiobookshelf/dataDir";
    };
    port = lib.mkOption {
      type = lib.types.port;
      default = 8081;
    };
    serviceTrigger = lib.mkOption {
      type = lib.types.str;
      default = "mnt-localLuks.service";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 8000 ];
    services.audiobookshelf = {
      enable = true;
      inherit (cfg) dataDir port;
      openFirewall = true;
      host = "0.0.0.0";
    };
    systemd.services.audiobookshelf = {
      description = lib.mkForce "Audiobookshelf (After localLuks mount)";
      requires    =             [ "${cfg.serviceTrigger}" ];
      after       =             [ "${cfg.serviceTrigger}" ];
      wantedBy    = lib.mkForce [ "${cfg.serviceTrigger}" ];
    };
  };
}

