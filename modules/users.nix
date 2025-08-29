{ config, pkgs, lib, ... }:

let
  cfg = config.users;
in
{
  options.users = {
    enable = lib.mkEnableOption "users";
    hashedPasswordFile = lib.mkOption {
      type = lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.root.hashedPasswordFile = "${cfg.hashedPasswordFile}";
    users.users.andrew = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; 
      hashedPasswordFile = "${cfg.hashedPasswordFile}";
    };
  };
}

