{
  description = "System Configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.lenovo = nixpkgs.lib.nixosSystem {
        modules = [ ./hosts/lenovo/configuration.nix ];
        system = "x86_64-linux";
        specialArgs = { 
          localPersist = {
            device     = "/dev/disk/by-uuid/9e831367-26eb-4ece-a7a5-666d46034160";
            mountPoint = "/mnt/localPersist";
          };
          localLuks = {
            device     = "/dev/nvme0n1p5";
            mapperName = "persist-enc";
            mountPoint = "/mnt/localLuks";
          };
        };
      };

    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
        modules = [ ./hosts/pc/configuration.nix ];
        system = "x86_64-linux";
        specialArgs = { 
          localPersist = {
            device     = "/dev/disk/by-uuid/75859c55-d8df-4c97-a74f-859f49e3f85a";
            mountPoint = "/mnt/localPersist";
          };
          localLuks = {
            device     = "/dev/disk/by-uuid/83ea2481-f20e-4e11-8506-fa63c65524f4";
            mapperName = "persist-enc";
            mountPoint = "/mnt/localLuks";
          };
        };
      };

#    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
#      system = "x86_64-linux";
#      modules = [
#        ./hosts/pc/configuration.nix
#    	  ./modules
#      ];
#    };

  };
}
