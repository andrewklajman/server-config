{ config, pkgs, lib, ... }:


{
  config = {
    networking.extraHosts = ''
      192.168.0.232 dell-server
    '';
  };

}

