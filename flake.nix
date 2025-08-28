{
  description = "System Configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

  outputs = { self, nixpkgs, ... }@inputs: 
    let 
      mkNixosConfig = modulePath: nixpkgs.lib.nixosSystem {
        modules = [ modulePath ];
        system = "x86_64-linux";
      };
    in
    {
      nixosConfigurations = {
        lenovo = mkNixosConfig ./hosts/lenovo/configuration.nix;
        lenovo-server = mkNixosConfig ./hosts/lenovo-server/configuration.nix;
      };

#      nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
#        modules = [ ./hosts/pc/configuration.nix ];
#        system = "x86_64-linux";
#        specialArgs = { 
#          localPersist = {
#            device     = "/dev/disk/by-uuid/75859c55-d8df-4c97-a74f-859f49e3f85a";
#            mountPoint = "/mnt/localPersist";
#          };
#          localLuks = {
#            device     = "/dev/nvme0n1p4";
#            mapperName = "persist-enc";
#            mountPoint = "/mnt/localLuks";
#          };
#        };
#      };

    };
}
