{ config, lib, pkgs, ... }:

let 
  unlock = pkgs.writeShellScriptBin "unlock" '' 
    if [[ "$HOSTNAME" == "pc" ]]; then
      echo PC Decrypt
      doas cryptsetup open /dev/nvme0n1p4 persist-enc
    else
      echo Lenovo Decrypt
      doas cryptsetup open /dev/nvme0n1p5 persist-enc
    fi

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
    slstatus
    st tabbed
    xclip
    mullvad-browser-andrew
  ];

  nixpkgs.overlays = [
    (self: super: {
      dwm = super.dwm.overrideAttrs (oldAttrs: rec {
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.xorg.libXext ];
        patches = [ ./patch.dwm.9.config.def.h.diff ];
      });
    })
  ];
  
#  services.xserver.displayManager.startx = {
#    enable = true;
#    #generateScript = true;
#    #extraCommands = ''
#    #  slstatus &
#    #'';
#  };
#  environment.etc."X11/xinit/xinitrc".text = ''
#    ${lib.getExe pkgs.slstatus} &
#  '';

  services = {
    xserver = {
      logFile = "/home/andrew/xlog";
      enable = true;
      displayManager = {
        lightdm.enable = true;
        setupCommands = ''
          ${pkgs.slstatus}/bin/slstatus &
        '';
      };
 
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

