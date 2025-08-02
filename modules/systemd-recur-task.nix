{ config, pkgs, lib, ... }:

{

  options.systemd-recur-task.enable = lib.mkEnableOption "systemd-recur-task"; 

  config = lib.mkIf config.systemd-recur-task.enable {
    systemd.timers."systemd-recur-task" = {
      wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "daily";
          Persistent = "true";
          Unit = "systemd-recur-task.service";
        };
    };
    
    systemd.services."systemd-recur-task" = {
      enable = true;
      script = ''
        ${pkgs.taskwarrior3}/bin/task rc.dateformat=HN add Rec: Read book until:2300 +next +recur
        ${pkgs.taskwarrior3}/bin/task rc.dateformat=HN add Rec: Goto gym  until:2300 +next +recur
        ${pkgs.taskwarrior3}/bin/task rc.dateformat=HN add Rec: Clean apartment  until:2300 +next +recur
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "andrew";
      };
    };
  };
}
