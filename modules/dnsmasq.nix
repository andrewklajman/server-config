{ config, pkgs, lib, localLuks, ... }:

{
  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "tailscale0";
      address = [ 
        "/abs/100.70.63.101"
        "/torrent/100.70.63.101"
      ];
      server = [ "8.8.8.8" "8.8.4.4" ];
    };
  };
}
