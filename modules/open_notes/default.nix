{ config, pkgs, lib, ... }:

let 
  cfg = config.open-notes;
  tag-with-title-sh = import ./tag_with_title.nix pkgs;
  tag-without-title-sh = import ./tag_without_title.nix pkgs;
  tag-sh = import ./tag.nix pkgs tag-with-title-sh tag-without-title-sh;
in
{
  options.open-notes = {
    enable = lib.mkEnableOption "open-notes";
    DirNotes = lib.mkOption {
      type = lib.types.str;
      default = "/home/andrew/luks/Documents/open_notes/notes";
    };
    DirTags = lib.mkOption {
      type = lib.types.str;
      default = "/home/andrew/luks/Documents/open_notes/tags";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      tag-sh
      tag-with-title-sh
      tag-without-title-sh
    ];

    systemd.timers."open_notes" = {
      wantedBy = [ "timers.target" ];
        timerConfig = {
          #OnCalendar = "*:1/1";
          OnCalendar = "*:5/10";
          Persistent = "true";
          Unit = "open_notes.service";
        };
    };
    
    systemd.services."open_notes" = {
      enable = true;
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${tag-sh}/bin/tag";
        User = "andrew";
      };
    };
  };
}

