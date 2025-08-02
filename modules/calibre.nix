{ config, pkgs, lib, ... }:

{
  options.calibre.enable = lib.mkEnableOption "calibre";

  config = lib.mkIf config.calibre.enable  {
    environment.systemPackages = [ pkgs.calibre ];
    services.udisks2.enable = true;
  };
}
