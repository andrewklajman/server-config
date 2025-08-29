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

    ( makeBasicModule "bluetooth" { 
        services.blueman.enable = true;
        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
          settings = {
            General = {
              Experimental = true; # Show battery charge of Bluetooth devices
            };
          };
        };
    } )

    ( makeBasicModule "pipewire" { 
        services.pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
        };
    } )
    
    ( makeBasicModule "bootlimit" { 
        boot.loader.systemd-boot.configurationLimit = 10;
        nix.settings.auto-optimise-store = true;
        nix.gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 1w";
        };

    } )

    ( makeBasicModule "manPages" { 
        documentation = {
          enable = true;
          man.enable = true;
          dev.enable = true;
        };
    } )

    ( makeBasicModule "diskusage" { 
        boot.loader.systemd-boot.configurationLimit = 10;
        nix.settings.auto-optimise-store = true;
        nix.gc = {
          automatic = true;
          dates = "weekly";
          options = "--delete-older-than 1w";
        };
    } )

  ];
}

