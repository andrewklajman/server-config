{ config, pkgs, lib, ... }:

let 
  cfg = config.tailscale-userspace;
  mullvad-browser-proxy = pkgs.writeShellScriptBin "mullvad-browser-tailscale" '' 
    mullvad-browser --profile /home/andrew/luks/mullvad-profiles/tailscale
  '';
in 
{
  options.tailscale-userspace = {
    enable = lib.mkEnableOption "tailscale-userspace";
    configDir = lib.mkOption {
      type = lib.types.str;
    };
    proxy = lib.mkOption {
      type = lib.types.str;
      default = "localhost:1055";
    };
  };

  config = 
    let
      server_ip = "100.98.178.79";
      authKeyFile = "${cfg.configDir}/tailscale.authkey";
      state = "${cfg.configDir}/tailscaled.state";
      inherit (cfg) proxy;
    in 
      lib.mkIf cfg.enable {
        environment.systemPackages = [ mullvad-browser-proxy ];

        networking.extraHosts = ''
            ${server_ip} abs
            ${server_ip} torrent
            ${server_ip} homepage
            ${server_ip} gitea
        '';

        services.tailscale = {
          enable = true;
          openFirewall = true;
          inherit authKeyFile;
        };

        systemd.services.tailscaled.serviceConfig = {
          ExecStart = [
            ""
            "${pkgs.tailscale}/bin/tailscaled --state=${state} --tun=userspace-networking --socks5-server=${proxy} --outbound-http-proxy-listen=${proxy}"
          ];
        };

      };
}
