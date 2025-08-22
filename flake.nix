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
      system = "x86_64-linux";
      modules = [
        ./hosts/pc/configuration.nix
    	  ./modules
      ];
    };

  };
}
