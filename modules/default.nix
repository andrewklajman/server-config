{ config, pkgs, lib, ... }:

let 
  makeBasicModule =  moduleName: moduleContent: {
    options.${moduleName}.enable = lib.mkEnableOption "${moduleName}";
    config = lib.mkIf config.${moduleName}.enable moduleContent;
  };
in

{
  imports = [
    ./audiobookshelf.nix
    ./dwm-basic
    ./dwm-enhanced
    # ./environment
    ./mullvad.nix
    ./networking.nix
    ./networkmanager.nix
    ./neovim
    ./openssh.nix
    ./personal-security
    ./retroarch.nix
    ./qbittorrent-client.nix
    ./qbittorrent-server.nix
    ./vsftpd-ftp-books.nix
    ./zsh.nix

    ( makeBasicModule "calibre" {
        services.udisks2.enable = true;
        services.calibre-server = {
          enable = true;
          libraries = [ "${config.consts.localLuks.mountPoint}/calibre" ];
        }; 
    } )

    ( makeBasicModule "users" { 
        users.users.root.initialPassword = "pass";
        users.users.andrew = {
          isNormalUser = true;
          extraGroups = [ "wheel" ]; 
          initialPassword = "pass";
        };
    } )

    ( makeBasicModule "doas" { 
        security.sudo.enable = false;
        security.doas = {
          enable = true;
          extraRules = [
            {
              users = ["andrew"];
              keepEnv = true; 
              persist = true;
            }
          ];
        };
    } )

    ( makeBasicModule "sessionVariables" { 
        environment = {
          sessionVariables = {
            PROMPT = "%n@%m %~> ";
            EDITOR = "nvim";
          };
        };
    } )
     
    ( makeBasicModule "basePackages" { 
        environment.systemPackages = with pkgs; [ 
          alsa-utils
          arandr autorandr
          cryptsetup
          btop
          entr
          jq
          mpv
          ncdu
          ranger
          yubikey-manager
          yt-dlp
          cups-pdf-to-pdf
          ledger
	        wget
        ];
    } )

  ];
}

