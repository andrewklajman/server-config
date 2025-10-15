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
  audio-create = pkgs.writeShellScriptBin 
    "audio_create" 
    '' ${builtins.readFile ./audio_create.sh} '';
  tag-audio = pkgs.writeShellScriptBin 
    "tag_audio" 
    '' ${builtins.readFile ./tag_audio.sh} '';

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
      audio-create
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
        tag-audio
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

