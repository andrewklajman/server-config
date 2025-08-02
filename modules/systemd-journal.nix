{ config, pkgs, lib, ... }:
# https://www.reddit.com/r/NixOS/comments/1kope9g/problem_with_running_a_systemd_service_running_a/
{
  options.systemd-journal.enable = lib.mkEnableOption "systemd-journal";

  config = lib.mkIf config.systemd-journal.enable {
    systemd.timers."systemd-journal" = {
      wantedBy = [ "timers.target" ];
        timerConfig = {
          #OnCalendar = "*:5/10";
          OnCalendar = "daily";
          Persistent = "true";
          Unit = "systemd-journal.service";
        };
    };
    
# https://www.reddit.com/r/NixOS/comments/1kope9g/problem_with_running_a_systemd_service_running_a/
# ${pkgs.python3}/bin/python3 /home/andrew/Documents/notes/scripts/journal.py

    systemd.services."systemd-journal" = {
      enable = true;
      script = ''
        ${pkgs.git}/bin/git -C /home/andrew/Documents/notes add .
        ${pkgs.git}/bin/git -C /home/andrew/Documents/notes commit -m 'Auto Commit'
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "andrew";
      };
    };
  };
}
