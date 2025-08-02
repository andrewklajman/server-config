{ config, pkgs, lib, ... }:

{
  options.doas.enable = lib.mkEnableOption "doas";
  config = lib.mkIf config.doas.enable {
    security.doas.enable = true;
    security.sudo.enable = false;
  };
}
