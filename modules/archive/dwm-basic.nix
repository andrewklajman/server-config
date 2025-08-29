{ config, lib, pkgs, ... }:

{
  options.dwm-basic.enable = lib.mkEnableOption "dwm-basic";
  config = lib.mkIf config.dwm-basic.enable {
    services = {
      xserver = {
        enable = true;
        displayManager.lightdm.enable = true;
        windowManager.dwm.enable = true;
      };
    };

  }; 
}

