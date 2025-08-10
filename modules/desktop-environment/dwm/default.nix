{ config, lib, pkgs, ... }:

let 
  unlock = pkgs.writeShellScriptBin "unlock" '' 
    doas cryptsetup open /dev/nvme0n1p5 persist-enc
    doas mkdir /persist-enc
    doas mount /dev/mapper/persist-enc /persist-enc
  '';
  mullvad-browser-andrew = pkgs.writeShellScriptBin "mullvad-browser-andrew" '' 
    mullvad-browser --profile /persist-enc/mullvad-profiles/andrew
  '';
in
{
  fonts.packages = with pkgs; [ source-code-pro font-awesome ];
  environment.systemPackages = with pkgs; [ 
    unlock
    dmenu 
    st tabbed
    xclip
    mullvad-browser-andrew
  ];

  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.xorg.libXext ];
        patches = [ ./patch.dwm.8.config.def.h.diff ];
      });
    })
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

# Auto login
  services.displayManager.defaultSession = "none+dwm";
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "andrew";
  
}

