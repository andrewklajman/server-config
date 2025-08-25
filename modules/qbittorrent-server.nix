{ config, pkgs, lib, localLuks, ... }:

let
  cfg = config.qbittorrent-server;
in
{
  options.qbittorrent-server = {
    enable = lib.mkEnableOption "qbittorrent-server";
    profileDir = lib.mkOption {
      type = lib.types.str;
      default = "${localLuks.mountPoint}/torrent/profile";
    };
    webuiPort = lib.mkOption {
      type = lib.types.port;
      default = 8080;
    };
    serviceTrigger = lib.mkOption {
      type = lib.types.str;
      default = "mnt-localLuks.service";
    };
  };

  config = lib.mkIf cfg.enable {
    services = {
      qbittorrent = {
        enable = true;
        inherit (cfg) profileDir webuiPort;

      };
    };

    systemd.services.qbittorrent = {
      description = lib.mkForce "qbittorrent BitTorrent client (After localLuks mount)";
      requires =             [ "${cfg.serviceTrigger}" ];
      after    =             [ "${cfg.serviceTrigger}" ];
      wantedBy = lib.mkForce [ "${cfg.serviceTrigger}" ];
    };

  };
}

