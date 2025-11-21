{
  description = "System Configuration";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.copyparty.url = "github:9001/copyparty";

  outputs = { self, nixpkgs, copyparty, ... }@inputs: 
    let 
      mkNixosConfig = modulePath: nixpkgs.lib.nixosSystem {
        modules = [ modulePath ];
        system = "x86_64-linux";
        specialArgs = { inherit copyparty; };
      };
    in
    {
      nixosConfigurations = {
        dell =          mkNixosConfig ./hosts/dell/configuration.nix;
        dell-server =   mkNixosConfig ./hosts/dell-server/configuration.nix;
        lenovo =        mkNixosConfig ./hosts/lenovo/configuration.nix;
        lenovo-server = mkNixosConfig ./hosts/lenovo-server/configuration.nix;
        system76 =      mkNixosConfig ./hosts/system76/configuration.nix;
      };
    };
}
