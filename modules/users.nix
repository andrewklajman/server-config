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
    # mkpasswd > /mnt/localLuks/...
    users.users.root.hashedPasswordFile = "${cfg.hashedPasswordFile}";
    users.users.andrew = {
      isNormalUser = true;
      extraGroups = [ "wheel" "networkmanager" ]; 
      hashedPasswordFile = "${cfg.hashedPasswordFile}";
    };
  };
}

