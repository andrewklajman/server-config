{
  description = "System Configuration";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.lenovo = 
      let 
        localPersist = {
          device = "/dev/disk/by-uuid/9e831367-26eb-4ece-a7a5-666d46034160";
          mountPoint = "/mnt/localPersist";
        };
        localLuks = {
          device = "/dev/nvme0n1p5";
          mapperName = "persist-enc";
          mountPoint = "/mnt/localLuks";
        };
      in 

      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit localPersist localLuks; };
        modules = [
          ./hosts/lenovo/configuration.nix
          ./modules
          ( { config, ... }: { 
              audiobookshelf.enable = false; 
              torrent.enable        = true;
              virt-manager.enable   = true;
              personal-security = {
                enable              = true;
                gnupgHome           = "${localPersist.mountPoint}/persistence/apps/gnupg";
                passwordStoreDir    = "${localPersist.mountPoint}/persistence/apps/password-store";
              };
              mullvad = { 
                enable = true; 
                mullvadSettingsDir = "${localPersist.mountPoint}/persistence/apps/mullvad/MULLVAD_SETTINGS_DIR/";
                mullvadCacheDir = "${localPersist.mountPoint}/persistence/apps/mullvad/MULLVAD_CACHE_DIR/";
              };
            })
        ];
      };

    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/pc/configuration.nix
    	  ./modules
#        ( { config, ... }: { 
#             mullvad = { 
#               enable = true; 
#               mullvadSettingsDir = "${localPersist}/persistence/apps/mullvad/MULLVAD_SETTINGS_DIR/";
#               mullvadCacheDir = "${localPersist}/persistence/apps/mullvad/MULLVAD_CACHE_DIR/";
#             };
#          })
      ];
    };

  };
}
