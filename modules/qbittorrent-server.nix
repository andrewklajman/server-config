{ config, pkgs, lib, ... }:

let
  cfg = config.qbittorrent-server;
  luks = config.consts.localLuks.mountPoint;
in
{
  options.qbittorrent-server = {
    enable = lib.mkEnableOption "qbittorrent-server";
    profileDir = lib.mkOption {
      type = lib.types.str;
      default = "${luks}/torrent/profile";
    };
    webuiPort = lib.mkOption {
      type = lib.types.port;
      default = 8080;
    };
    serviceTrigger = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
    };
  };

  config = lib.mkMerge [
    ( lib.mkIf cfg.enable {
        services = {
          qbittorrent = {
            enable = true;
            inherit (cfg) profileDir webuiPort;
            openFirewall = true;
          };
        }; 

    } )

    ( lib.mkIf (cfg.serviceTrigger != null) {
        systemd.services.qbittorrent = {
          description = lib.mkForce "qbittorrent BitTorrent client (after trigger)";
          requires =             [ "${cfg.serviceTrigger}" ];
          after    =             [ "${cfg.serviceTrigger}" ];
          wantedBy = lib.mkForce [ "${cfg.serviceTrigger}" ];
        };
    } )

  ];
}

