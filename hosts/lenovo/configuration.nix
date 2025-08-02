{ config, lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  # boot.initrd.luks.devices.luksroot = {
  #     device = "/dev/disk/by-uuid/44a35f17-41b6-4601-8a93-909f3578b4fd";
  #     preLVM = true;
  #     allowDiscards = true;
  # };

  system.stateVersion = "25.05";
}


# boot.initrd.luks.luks.devices.persist = {
#   device = "/dev/disk/by-label/persist-encrypted"
#   preLVM = true;
#   allowDiscards = true;  # Consider removing
# }
# fileSystems."/persist" = { 
#   device = "/dev/disk/by-uuid/12EE-24BE";
#   fsType = "ext4";
#   # options = [ "fmask=0022" "dmask=0022" ];
# };
