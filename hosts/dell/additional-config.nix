{ config, pkgs, lib, ... }:


{
  config = {
    networking.extraHosts = ''
      dell-server 192.168.0.232
    '';
  };

}

