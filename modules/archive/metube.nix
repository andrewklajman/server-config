{ config, pkgs, lib, ... }:

{
  options.metube.enable = lib.mkEnableOption "metube";

  config = lib.mkIf config.metube.enable {
    virtualisation.oci-containers.containers.metube = {
      image = "ghcr.io/alexta69/metube";
      ports = [ "8081:8081" ];
      volumes = [ "/etc/nixos/secrets/ssl:/ssl" ];
      user= "root";
      extraOptions = [ "--restart=always" ];
      environment = {
        HTTPS = "true";
	      CERTFILE = "/ssl/cert.pem";
        KEYFILE = "/ssl/key.pem";
      };
    };
  };
}
