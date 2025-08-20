{ config, pkgs, lib, ... }:

{
  options.tailscale.enable = lib.mkEnableOption "tailscale";

  config = lib.mkIf config.tailscale.enable {
    services.tailscale = {
      enable = true;
      authKeyFile = config.age.secrets.tailscale.path;
      extraDaemonFlags = [ 
        "--tun=userspace-networking" 
        "--socks5-server=127.0.0.1:1055"
      ];
    };

    systemd.services.tailscaled = {
      after = [ "mullvad-conn-check.service" ];
      serviceConfig.Type = "oneshot";
    };
  };
}
