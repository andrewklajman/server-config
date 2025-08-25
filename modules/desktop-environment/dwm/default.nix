{ config, lib, pkgs, localLuks, ... }:

let 
  unlock = pkgs.writeShellScriptBin "unlock" '' 
    doas cryptsetup open ${localLuks.device} ${localLuks.mapperName}
    doas mkdir ${localLuks.mountPoint}
    doas mount /dev/mapper/${localLuks.mapperName} ${localLuks.mountPoint}
    doas systemctl start mnt-localLuks.service
  '';
  unlock_p = pkgs.writeShellScriptBin "unlock_p" '' 
    doas cryptsetup open /mnt/localLuks/.ZNfKKTx03EVnh unlock_p
    doas mkdir /home/andrew/unlock_p
    doas mount /dev/mapper/unlock_p /home/andrew/unlock_p
    mullvad-browser --profile /home/andrew/unlock_p/mullvad-browser &
  '';
  mullvad-browser-andrew = pkgs.writeShellScriptBin "mullvad-browser-andrew" '' 
    mullvad-browser --profile ${localLuks.mountPoint}/mullvad-profiles/andrew
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
    ls -l /mnt | grep localLuks > /dev/null
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

  systemd.services.mnt-localLuks = { 
    enable = true;
    serviceConfig.ExecStart = "${pkgs.coreutils}/bin/echo mnt-localLuks trigger has run"; 
  };

  fonts.packages = with pkgs; [
    source-code-pro font-awesome 
    nerd-fonts.code-new-roman
  ];

  environment.systemPackages = with pkgs; [ 
    unlock unlock_p
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

