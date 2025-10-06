{ config, pkgs, lib, ... }:

let
  cfg = config.taskwarrior;
  luks = config.consts.localLuks.mountPoint;
in
{
  options.taskwarrior = {
    enable = lib.mkEnableOption "taskwarrior";
    taskrc = lib.mkOption {
      type = lib.types.str;
      default = "${luks}/Documents/taskwarrior/taskrc";
    };
    taskdata = lib.mkOption {
      type = lib.types.str;
      default = "${luks}/Documents/taskwarrior/taskdata";
    };
  };
  
  config = lib.mkIf cfg.enable {
    environment = {
      systemPackages = [ pkgs.taskwarrior3 ];
      sessionVariables = { 
        TASKRC = "${cfg.taskrc}";
        TASKDATA = "${cfg.taskdata}";
      };
    };
  };
}
