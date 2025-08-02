{ config, lib, pkgs, ... }:

{
  fonts.packages = with pkgs; [ source-code-pro font-awesome ];
  environment.systemPackages = with pkgs; [ 
    dmenu 
    st tabbed
    xclip
  ];

  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.xorg.libXext ];
        patches = [ ./patch.dwm.7.config.def.h.diff ];
      });
    })
  ];
  
  services = {
    xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      xkb = {
        layout = "au"; 
        variant = "";
      };
      deviceSection = ''
        Option "DRI" "2"
        Option "TearFree" "true"
      '';
      displayManager = {
        startx.enable = true;
        gdm.enable = true;
      };
    };
  };
  
}

