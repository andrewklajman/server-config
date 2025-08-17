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
  slstatus_command = pkgs.writeShellScriptBin "slstatus_command" '' 
    # --- Internet Status --- #
    ping -c 1 www.google.com > /dev/null
    if [ $? -eq 0 ]; then 
      # Internet Connected
      if [[ "$(mullvad status | head -n1)" == "Connected" ]]; then
        WIRELESS_BAR="󰖩  |"
      else
        WIRELESS_BAR="󰖩 |"
      fi
    else
      # Internet Unavailable
      WIRELESS_BAR="󱛅 |"
    fi
    
    # --- Date Bar --- #
    DATE_BAR="$(date '+%A %B %d %r')"
    
    # --- Encrypted Disk --- #
    ls -l / | grep persist-enc > /dev/null
    if [ $? -eq 0 ]; then
      ENCRYPT_BAR="󰢬 |"
    else
      ENCRYPT_BAR=""
    fi
    
    # --- Battery Capacity --- #
    BAT_BAR="BAT $(cat /sys/class/power_supply/BAT0/capacity)% |"
    
    echo " $BAT_BAR $ENCRYPT_BAR $WIRELESS_BAR $DATE_BAR "
  '';
in
{
  # fonts.packages = builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);

  # fonts.packages = with pkgs; [ 
  #   nerdfonts 
  #   #source-code-pro 
  #   #font-awesome 
  # ];

  fonts.packages = with pkgs; [
    source-code-pro font-awesome 
    nerd-fonts.code-new-roman
  ];

  environment.systemPackages = with pkgs; [ 
    unlock
    dmenu 
    slstatus slstatus_command
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
      slstatus = super.slstatus.overrideAttrs (oldAttrs: rec {
        patches = [ ./patch.slstatus.diff ];
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
        #setupCommands = ''
        #  ${pkgs.slstatus}/bin/slstatus &
        #'';
        #extraCommands = ''
        #  ${pkgs.slstatus}/bin/slstatus &
        #'';
        sessionCommands = ''
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

