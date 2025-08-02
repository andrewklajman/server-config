{ config, lib, pkgs, ... }:

{
  # Pre 25.11
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

#  # As of 25.11
#  services.displayManager.gdm.enable = true;
#  services.desktopManager.gnome.enable = true;

#  services = {
#    xserver = {
#      enable = true;
#      xkb = {
#        layout = "au"; 
#        variant = "";
#      };
#      deviceSection = ''
#        Option "DRI" "2"
#        Option "TearFree" "true"
#      '';
#      displayManager = {
#        startx.enable = true;
#        gdm.enable = true;
#      };
#    };
#  };
}

