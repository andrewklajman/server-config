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
            desktop-manager           = "dwm";
            doas.enable               = true;
            docker.enable             = false;
            personal-security = {
              enable                  = true;
              gnupgHome               = "/persist/gnupg";
              passwordStoreDir        = "/persist/password-store";
            };
            mullvad = { 
              enable = true; 
              mullvadSettingsDir = "/persist/persistence-mullvad/MULLVAD_SETTINGS_DIR/";
              mullvadCacheDir = "/persist/persistence-mullvad/MULLVAD_CACHE_DIR/";
            };
            qbittorrent.enable        = true;
            systemd-journal.enable    = false;
            systemd-recur-task.enable = false;
            tmux.enable               = false;
            virt-manager.enable       = true;
            zsh.enable                = true;
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
