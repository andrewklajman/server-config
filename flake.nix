{
  description = "System Configuration";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
  inputs.agenix.url = "github:ryantm/agenix";
  inputs.impermanence.url = "github:nix-community/impermanence";

  outputs = { self, nixpkgs, agenix, impermanence, ... }@inputs: {
    nixosConfigurations.lenovo = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        agenix.nixosModules.default
        impermanence.nixosModules.impermanence
        ./hosts/lenovo/configuration.nix
        ./modules
        ( { config, ... }: { 
            audiobookshelf.enable     = false; 
            qbittorrent.enable        = true;
            personal-security = {
              enable                  = true;
              gnupgHome               = "/persist/persistence/apps/gnupg";
              passwordStoreDir        = "/persist/persistence/apps/password-store";
            };
            mullvad = { 
              enable = true; 
              mullvadSettingsDir = "/persist/persistence/apps/mullvad/MULLVAD_SETTINGS_DIR/";
              mullvadCacheDir = "/persist/persistence/apps/mullvad/MULLVAD_CACHE_DIR/";
            };
          })
      ];
    };

    nixosConfigurations.pc = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/pc/configuration.nix
    	  ./modules
        ( { config, ... }: { 
            desktop-manager           = "dwm";
            doas.enable               = true;
            zsh.enable                = true;
          })
      ];
    };

  };
}
