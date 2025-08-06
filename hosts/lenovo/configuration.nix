{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  users.users.andrew = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  fileSystems."/etc/shadow" = { 
    device = "/persist/persistence/system/shadow";
    options = [ "bind" ];
  };

  fileSystems."/etc/NetworkManager/system-connections" = { 
    device = "/persist/persistence/system/system-connections";
    options = [ "bind" ];
  };

  fileSystems."/home/andrew/.zshrc" = { 
    device = "/persist/persistence/andrew/zshrc";
    options = [ "bind" ];
  };

  fileSystems."/home/andrew/.ssh" = { 
    device = "/persist/persistence/andrew/ssh";
    options = [ "bind" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05";

}
