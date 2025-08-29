{ config, pkgs, lib, ... }:

let
  cfg = config.openssh;
in
{
  options.openssh = {
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
  
  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ cfg.port ];

    fileSystems = {
#     https://discourse.nixos.org/t/ssh-sshd-3771-authentication-refused-bad-ownership-or-modes-for-directory/25662/4
      "${cfg.authKeyFile.mountPoint}" = { 
        device = "${cfg.authKeyFile.device}";
        options = [ "bind" ];
      };
      "${cfg.sshKey.mountPoint}" = { 
        device = "${cfg.sshKey.device}";
        options = [ "bind" ];
      };
    };

    services.openssh = {
      enable = true;
      ports = [ cfg.port ];
      openFirewall = true;
      settings = lib.mkIf cfg.keyFileOnlyAuth {
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
      };
    };

  };
}
