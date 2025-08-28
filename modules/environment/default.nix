{ config, pkgs, lib, ... }:

let 
  mp = config.consts.localPersist.mountPoint;
in 
{
  imports = [
    ./neovim
    ./zsh.nix 
  ];

  options.environment.enable = lib.mkEnableOption "environment";

  config = lib.mkIf config.environment.enable {
    zsh.enable = true; 
    neovim.enable = true;

  # Users
    users.users.root.hashedPasswordFile = "${mp}/persistence/system/hashedPasswordFile";
    users.users.andrew = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ];
      hashedPasswordFile = "${mp}/persistence/system/hashedPasswordFile";
    };
  
  # Bluetooth
    services.blueman.enable = true;
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true; # Show battery charge of Bluetooth devices
        };
      };
    };
  
  # Misc
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Audio
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  
  # Doas
    security.sudo.enable = false;
    security.doas = {
      enable = true;
      extraRules = [
        {
          users = ["andrew"];
          keepEnv = true; 
          persist = true;
        }
      ];
    };
  
  # Timezone
    time.timeZone = "Australia/Sydney";
  
  # Reducing disk space usage
    boot.loader.systemd-boot.configurationLimit = 10;
    nix.settings.auto-optimise-store = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  
  # Git
    programs.git = {
      enable = true;
      config = {
        safe.directory = [ 
          "${mp}/server-config" 
          "/home/andrew/server-config" 
        ];
        user.name = [ "andrew" ];
        user.email = [ "andrew.klajman@gmail.com" ];
      };
    };
  
  # Packages
    environment.systemPackages = with pkgs; [ 
      alsa-utils
      arandr autorandr
      cryptsetup
      btop
      entr
      jq
      mpv
      ncdu
      ranger
      yubikey-manager
      yt-dlp
      cups-pdf-to-pdf
      ledger
    ];
  
  # Environment variables
    environment = {
      sessionVariables = {
        PROMPT = "%n@%m %~> ";
        EDITOR = "nvim";
      };
    };
  
  # Documentation
    documentation = {
      enable = true;
      man.enable = true;
      dev.enable = true;
    };

  };
}
