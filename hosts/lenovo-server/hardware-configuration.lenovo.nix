{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "uas" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ 
    "kvm-intel" 
    "iwlwifi"  # Ensures wireless works
  ];

  fileSystems."/" = { 
    device = "tmpfs";
    fsType = "tmpfs";
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4625-0759";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems.${config.consts.localPersist.mountPoint} = 
    { 
      device = "${config.consts.localPersist.device}";
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
