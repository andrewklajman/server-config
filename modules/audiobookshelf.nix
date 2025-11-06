{ config, pkgs, lib, localLuks, ... }:

let
  cfg = config.audiobookshelf;
  luks = config.consts.localLuks.mountPoint;

   abs = pkgs.writeShellScriptBin "abs" '' 
     audiobookshelf \
        --host 0.0.0.0 \
        --port ${cfg.port} \
        --config ${cfg.config}
   '';

in
{
  options.audiobookshelf = {
    enable = lib.mkEnableOption "audiobookshelf";
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "${luks}/audiobookshelf/dataDir";
    };
    port = lib.mkOption {
      type = lib.types.str;
      default = "8081";
    };
    config = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/localLuks/audiobookshelf/config";
    };
#    serviceTrigger = lib.mkOption {
#      type = lib.types.str;
#      default = "mnt-localLuks.service";
#    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ 
      pkgs.audiobookshelf 
      abs
    ];
    networking.firewall.allowedTCPPorts = [ 8081 80 ];



#     services.audiobookshelf = {
#       enable = true;
#       inherit (cfg) port;
#       openFirewall = true;
#       host = "0.0.0.0";
#     };
#     systemd.services.audiobookshelf = {
# # Working Directory mounted in the unlock script
#       description = lib.mkForce "Audiobookshelf (After localLuks mount)";
#       requires    =             [ "${cfg.serviceTrigger}" ];
#       after       =             [ "${cfg.serviceTrigger}" ];
#       wantedBy    = lib.mkForce [ "${cfg.serviceTrigger}" ];
#     };
  };
}

