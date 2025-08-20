{ config, pkgs, lib, localPersist, ... }:

{

  options.git.enable = lib.mkEnableOption "git";

  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;
      config =  {
        safe = {
          directory = [ 
            "${localPersist.mountPoint}/server-config" 
            "/home/andrew/server-config" 
          ];

        };
      };
    };
  };

}
