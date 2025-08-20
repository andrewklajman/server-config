{ config, pkgs, lib, localLuks, ... }:

{
  calibre.enable  = false;
  desktop-manager = "dwm";
  zsh.enable      = true;

  imports = [
    ./desktop-environment
    ./environment.nix
    ./mullvad.nix
    ./neovim
    ./personal-security
    ./retroarch.nix
    ./torrent.nix
    ./virt-manager.nix
    ./zsh.nix

    ( { config, ... }: { # .... calibre module
      options.calibre.enable = lib.mkEnableOption "calibre";
      config = lib.mkIf config.calibre.enable  {
        services.udisks2.enable = true;
        services.calibre-server = {
          enable = true;
          libraries = [ "${localLuks.mountPoint}/calibre" ];
        }; 
      }; 
    })

    ( { config, pkgs, lib, ... }: {
      options.audiobookshelf.enable = lib.mkEnableOption "audiobookshelf";
      config = lib.mkIf config.audiobookshelf.enable {
        networking.firewall.allowedTCPPorts = [ 8000 ];
        services.audiobookshelf = {
          enable = true;
          host = "0.0.0.0";
        };
      };
    })

  ];
}

