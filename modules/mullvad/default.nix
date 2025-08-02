{ config, pkgs, lib, ... }:

let
  cfg = config.services.mullvad-vpn;
in
with lib;
{
  imports = [ ./st-leonards.nix ];

  options.mullvad = {
    enable = lib.mkEnableOption "mullvad";
    mullvadSettingsDir = lib.mkOption { type = lib.types.str; };
    mullvadCacheDir = lib.mkOption { type = lib.types.str; };
  };

  config = lib.mkIf config.mullvad.enable {
    boot.kernelModules = [ "tun" ];

    networking.enableIPv6 = false;
    networking.networkmanager.enable = true;

    environment.systemPackages = [ 
      pkgs.mullvad-vpn 
      pkgs.mullvad-browser
    ];

    systemd.services.mullvad-daemon = {
      description = "Mullvad VPN daemon";
      wantedBy = [ "multi-user.target" ];
      wants = [
        "network.target"
        "network-online.target"
      ];
      after = [
        "network-online.target"
        "NetworkManager.service"
        "systemd-resolved.service"
      ];
      path = lib.optional config.networking.resolvconf.enable config.networking.resolvconf.package;
      startLimitBurst = 5;
      startLimitIntervalSec = 20;
      serviceConfig = {
        Environment = [
          "MULLVAD_SETTINGS_DIR=${config.mullvad.mullvadSettingsDir}"
          "MULLVAD_CACHE_DIR=${config.mullvad.mullvadCacheDir}"
        ];
        ExecStart = '' ${cfg.package}/bin/mullvad-daemon -v --disable-stdout-timestamps '';
        Restart = "always";
        RestartSec = 1;
      };
    };

  };
}
