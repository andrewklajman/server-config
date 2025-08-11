{ config, pkgs, lib, ... }:

{

  options.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      config =  {
        safe = {
          directory = [ "/persist/server" "/persist/server-config" ];
        };
      };
    };
  };

}
