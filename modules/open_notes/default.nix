{ config, pkgs, lib, ... }:

let 
  cfg = config.open-notes;
  tag-with-title = pkgs.writeShellScriptBin 
    "tag_with_title" 
    '' ${builtins.readFile ./tag_with_title.sh} '';
  tag-without-title = pkgs.writeShellScriptBin 
    "tag_without_title" 
    '' ${builtins.readFile ./tag_without_title.sh} '';
  tag = pkgs.writeShellScriptBin 
    "tag" 
    '' ${builtins.readFile ./tag.sh} '';

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

    systemd.timers."open_notes" = {
      wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*:5/10";
          Persistent = "true";
          Unit = "open_notes.service";
        };
    };
    
    systemd.services."open_notes" = {
      enable = true;
      path = [
        tag-with-title
        tag-without-title
      ];
      serviceConfig = {
        Type = "oneshot";
        Environment = [
          "DIR_NOTES=/home/andrew/luks/Documents/open_notes/notes"
          "DIR_TAGS=/home/andrew/luks/Documents/open_notes/tags"
        ];
        ExecStart = "${tag}/bin/tag $DIR_NOTES $DIR_TAGS";
        User = "andrew";
      };
    };
  };
}

