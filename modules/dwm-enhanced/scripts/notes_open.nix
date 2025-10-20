{ config, pkgs }:

let 
  localLuks = config.consts.localLuks;
in

pkgs.writeShellScriptBin "notes_open" ''
  ranger  ${localLuks.mountPoint}/critical/open_notes/tags
''

