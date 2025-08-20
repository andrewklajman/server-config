{ config, pkgs, lib, ... }:

{
  options.doas.enable = lib.mkEnableOption "doas";
  config = lib.mkIf config.doas.enable {

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

  };
}
