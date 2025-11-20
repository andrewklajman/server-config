{ config, pkgs, ... }:

{
  imports = [ 
    ./hardware-configuration.nix
    ./additional-config.nix
    ../../modules
  ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dell-server";

  networking.networkmanager.enable = true;
  time.timeZone = "Australia/Sydney";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.andrew = {
    isNormalUser = true;
    description = "andrew";
    extraGroups = [ "networkmanager" "wheel" ];
  };

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "andrew";

  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  nixpkgs.config.allowUnfree = true;

  system.stateVersion = "25.05";

}
