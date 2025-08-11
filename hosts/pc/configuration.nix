{ config, lib, pkgs, ... }:

{
  networking.hostName = "pc";

  imports = [ ./hardware-configuration.nix ];

  services.pcscd = {
    enable = true;
    plugins = [ pkgs.acsccid ];
  };

  users.users.root.hashedPasswordFile = "/persist/persistence/system/hashedPasswordFile";
  users.users.andrew = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPasswordFile = "/persist/persistence/system/hashedPasswordFile";
  };

  fileSystems."/etc/NetworkManager/system-connections" = { 
    device = "/persist/persistence/system/system-connections";
    options = [ "bind" ];
  };

  fileSystems."/home/andrew/persist" = { 
    device = "/persist";
    options = [ "bind" ];
  };

#  fileSystems."/home/andrew/.gitconfig" = { 
#    device = "/persist/persistence/andrew/gitconfig";
#    options = [ "bind" ];
#  };

  fileSystems."/home/andrew/.zshrc" = { 
    device = "/persist/persistence/andrew/zshrc";
    options = [ "bind" ];
  };

  fileSystems."/home/andrew/.ssh" = { 
    device = "/persist/persistence/andrew/ssh";
    options = [ "bind" ];
  };

  fileSystems."/root/.ssh" = { 
    device = "/persist/persistence/root/ssh";
    options = [ "bind" ];
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05";

}

