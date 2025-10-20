{ config, lib, pkgs, ... }:

let 
  localLuks              = config.consts.localLuks;
  script_args            = { inherit config pkgs; };
  unlock                 = import ./scripts/unlock.nix script_args;
  slstatus_command       = import ./scripts/slstatus_command.nix script_args;
  mullvad-browser-andrew = import ./scripts/mullvad-browser-andrew.nix script_args;
  hhy9i                  = import ./scripts/hhy9i.nix script_args;
  notes_open             = import ./scripts/notes_open.nix script_args;

in
{
  options.dwm-enhanced.enable = lib.mkEnableOption "dwm-enhanced";

  config = lib.mkIf config.dwm-enhanced.enable {
    systemd.services.mnt-localLuks = { 
      enable = true;
      serviceConfig.ExecStart = "${pkgs.coreutils}/bin/echo mnt-localLuks trigger has run"; 
    };
  
    fonts.packages = with pkgs; [
      source-code-pro font-awesome 
      nerd-fonts.code-new-roman
    ];
  
    environment.systemPackages = with pkgs; [ 
      xclip dmenu 
      st tabbed
      unlock
      slstatus slstatus_command
      mullvad-browser-andrew hhy9i
      notes_open
      dunst libnotify
    ];
  
    nixpkgs.overlays = [
      (self: super: {
        dwm = super.dwm.overrideAttrs (oldAttrs: rec {
          buildInputs = oldAttrs.buildInputs ++ [ pkgs.xorg.libXext ];
          patches = [ 
            ./dwm-patches/dwm-center-6.2.diff
            ./dwm-patches/dwm-config.diff
          ];
        });
        slstatus = super.slstatus.overrideAttrs (oldAttrs: rec {
          patches = [ ./patch.slstatus.diff ];
        });
      })
    ];
    
    services = {
      xserver = {
        logFile = "/home/andrew/xlog";
        enable = true;
        displayManager = {
          lightdm.enable = true;
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

  };
}

