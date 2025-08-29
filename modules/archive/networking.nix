{ config, pkgs, lib, localLuks, ... }:

let
  cfg = config.networking;
in
{
  imports = [
    ./mullvad.nix
  ];

  options.networking = {
    NetworkManager = {
      enable = lib.mkEnableOption "NetworkManagerEnable";
      config = lib.mkOption { type = lib.types.str; };
    };
    openssh = {
      enable = lib.mkEnableOption "openssh";
      keyFileOnlyAuth = lib.mkEnableOption "keyFileOnlyAuth";
      port = lib.mkOption { 
        type = lib.types.port; 
        default = 22;
      };
      sshKey = {
        device = lib.mkOption { type = lib.types.str; };
        mountPoint = lib.mkOption { type = lib.types.str; };
      };
      authKeyFile = {
        device = lib.mkOption { type = lib.types.str; };
        mountPoint = lib.mkOption { type = lib.types.str; };
      };
    };
    mullvad = {
      enable = lib.mkEnableOption "mullvad";
      configDir = lib.mkOption { type = lib.types.str; };
    };
  };
  
  config = lib.mkMerge [
    (lib.mkIf cfg.NetworkManager.enable {
      networking.networkmanager.enable = true; 
      fileSystems."/etc/NetworkManager/system-connections" = {
        device = "${cfg.NetworkManager.config}";
        options = [ "bind" ];
      };

    })


    (lib.mkIf cfg.openssh.enable {

      networking.firewall.allowedTCPPorts = [ cfg.openssh.port ];

# https://discourse.nixos.org/t/ssh-sshd-3771-authentication-refused-bad-ownership-or-modes-for-directory/25662/4
      fileSystems = {
        "${cfg.openssh.authKeyFile.mountPoint}" = { 
          device = "${cfg.openssh.authKeyFile.device}";
          options = [ "bind" ];
        };
        "${cfg.openssh.sshKey.mountPoint}" = { 
          device = "${cfg.openssh.sshKey.device}";
          options = [ "bind" ];
        };
      };

      services.openssh = {
        enable = true;
        ports = [ cfg.openssh.port ];
	      openFirewall = true;
	      settings = lib.mkIf cfg.openssh.keyFileOnlyAuth {
          PasswordAuthentication = false;
	        KbdInteractiveAuthentication = false;
        };
      };

    } )

    (lib.mkIf cfg.mullvad.enable { 
      mullvad = {
        enable = true;
        configDir = "${cfg.mullvad.configDir}";
      };
    } )

  ];
}

