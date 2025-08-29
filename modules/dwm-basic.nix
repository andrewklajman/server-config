{ config, lib, pkgs, ... }:

{
  options.dwm-basic.enable = lib.mkEnableOption "dwm-basic";
  config = lib.mkIf config.dwm-basic.enable {
    environment.systemPackages = with pkgs; [ 
      dmenu 
      st
      dwm
    ];
  
    services = {
      xserver = {
        enable = true;
        displayManager.lightdm.enable = true;
        windowManager.dwm.enable = true;
        xkb = {
          layout = "au"; 
          variant = "";
        };
        deviceSection = ''
          Option "DRI" "2"
          Option "TearFree" "true"
        '';
      };
    };
  }; 
}

