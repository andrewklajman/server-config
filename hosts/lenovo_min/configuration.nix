# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.enableIPv6 = false;
  networking.networkmanager.enable = true;

  users.users.root.initialPassword = "pass";
  users.users.andrew = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    initialPassword = "pass";
  };

  environment.systemPackages = with pkgs; [
    vim 
    wget
    git
  ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  boot.loader.systemd-boot.configurationLimit = 10;
  system.stateVersion = "25.05"; # Did you read the comment?

}

