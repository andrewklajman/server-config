{ config, lib, pkgs, localPersist, ... }:

let 
  bindMount = device: {
    inherit device;
    options = [ "bind" ];
  };
  mp = localPersist.mountPoint;
in

{

  fileSystems = {
    "/home/andrew/server-config" = bindMount "${mp}/server-config";
    "/home/andrew/rust" = bindMount "${mp}/rust";

    "/home/andrew/.gitconfig" = bindMount "${mp}/persistence/andrew/gitconfig";
    "/home/andrew/.zshrc" = bindMount "${mp}/persistence/andrew/zshrc";
    "/home/andrew/.ssh" = bindMount "${mp}/persistence/andrew/ssh";
    "/etc/NetworkManager/system-connections" = bindMount "${mp}/persistence/system/system-connections";
    "/root/.ssh" = bindMount "${mp}/persistence/root/ssh";
  };

  imports = [ 
    ./hardware-configuration.nix 
  ];

  services.pcscd = {
    enable = true;
    plugins = [ pkgs.acsccid ];
  };

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

  users.users.root.hashedPasswordFile = "${mp}/persistence/system/hashedPasswordFile";
  users.users.andrew = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    hashedPasswordFile = "${mp}/persistence/system/hashedPasswordFile";
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  system.stateVersion = "25.05";

}
