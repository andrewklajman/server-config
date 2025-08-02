{ config, pkgs, ... }:

{
#  # Variables
#  environment.variables = {
#    GNUPGHOME = "/persist/persist-encrypted/gnupg";
#    PASSWORD_STORE_DIR = "/persist/persist-encrypted/password-store";
#  };

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

  # Packages
  environment.systemPackages = with pkgs; [ 
    alsa-utils
    arandr autorandr
    cryptsetup
    btop
    git
    jq
    mpv
    ncdu
    ranger
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
