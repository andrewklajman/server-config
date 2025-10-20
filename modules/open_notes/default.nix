{ config, pkgs, lib, ... }:

let 
  cfg = config.open-notes;
  script = name: pkgs.writeShellScriptBin 
                    "${name}" '' ${builtins.readFile ./${name}.sh} '';

  tag               = script "tag";
  tag-with-title    = script "tag_with_title";
  tag-without-title = script "tag_without_title";

  quicknote         = script "quicknote";
  quicknote-journal = script "quicknote-journal";
  quicknote-health  = script "quicknote-health";
  quicknote-vimrc   = script "quicknote-vimrc";
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
    DirAudio = lib.mkOption {
      type = lib.types.str;
      default = "/home/andrew/luks/Documents/open_notes/audio";
    };
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = [
      quicknote
      quicknote-journal
      quicknote-health
      quicknote-vimrc
    ];

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
          "DIR_NOTES=${cfg.DirNotes}"
          "DIR_TAGS=${cfg.DirTags}"
          "DIR_AUDIO=${cfg.DirAudio}"
        ];
        #ExecStart = "${tag}/bin/tag $DIR_NOTES $DIR_TAGS";
        ExecStart = "${tag}/bin/tag";
        User = "andrew";
      };
    };
  };
}

