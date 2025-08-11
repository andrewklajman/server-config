{ config, pkgs, ... }:

{
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

  programs.git = {
    enable = true;
    config = {
      safe.directory = [ 
        "/persist/server" 
        "/persist/server-config" 
        "/home/andrew/persist/server-config" 
        "/home/andrew/server" 
        "/home/andrew/persist/server" 
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
}
