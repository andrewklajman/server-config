{ config, lib, pkgs, modulesPath, localPersist, ... }:
{
# Screen tearing - https://discourse.nixos.org/t/eliminate-screen-tearing-with-intel-mesa/14724/25
  services.picom = {
    enable = true;
    vSync = true;
  };

  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ 
    "kvm-intel" 
    "iwlwifi"  # Ensures wireless works
  ];

# Ensures wireless works
#    options iwlwifi d0i3_disable=1
#    options iwlwifi lar_disable=1
  boot.extraModprobeConfig = ''
    options iwlwifi 11n_disable=1 swcrypto=0 bt_coex_active=0 power_save=0
    options iwlmvm power_scheme=1
    options iwlwifi uapsd_disable=1

    options usbcore autosuspend=0
    options i915 modeset=1
    options iwlwifi swcrypto=0
    options iwlwifi power_save=0
    options iwlwifi uapsd_disable=1
    options iwlmvm power_scheme=1

  '';

  boot.extraModulePackages = [ ];

  fileSystems."/" = { 
    device = "tmpfs";
    fsType = "tmpfs";
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4625-0759";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems.${localPersist.mountPoint} = 
    { 
      device = "${localPersist.device}";
      fsType = "ext4";
      neededForBoot = true;
    };

  fileSystems."/nix" =
    { device = "/dev/disk/by-uuid/0e90433d-d7b7-4153-a6ca-994b4ce3780a";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/6736f948-317d-4bb7-a662-1f6122944b9a"; }
    ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
