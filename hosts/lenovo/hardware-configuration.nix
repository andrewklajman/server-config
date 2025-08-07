{ config, lib, pkgs, modulesPath, ... }:

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
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "tmpfs";
      fsType = "tmpfs";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/4625-0759";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  fileSystems."/persist" =
    { device = "/dev/disk/by-uuid/9e831367-26eb-4ece-a7a5-666d46034160";
      fsType = "ext4";
      neededForBoot = true;
    };

  #boot.initrd.luks.devices."persist-enc".device = "/dev/disk/by-uuid/64d3c28f-b3fc-4252-8cf0-13f92c75440a";
  #fileSystems."/persist-enc" =
  #  { device = "/dev/disk/by-uuid/81d7125e-4c79-48ff-8723-e6774fddba16";
  #    fsType = "ext4";
  #  };


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
