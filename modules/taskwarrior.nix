{ config, pkgs, lib, localLuks, ... }:

let
  cfg = config.taskwarrior;
in
{
  options.taskwarrior = {
    enable = lib.mkEnableOption "taskwarrior";
  };
  
  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.taskwarrior3 ];
  };
}
