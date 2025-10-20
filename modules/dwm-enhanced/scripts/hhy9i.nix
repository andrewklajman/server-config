{ config, pkgs }:

let 
  localLuks = config.consts.localLuks;
in

pkgs.writeShellScriptBin "hhy9i" '' 
  mullvad-browser --profile ${localLuks.mountPoint}/mullvad-profiles/id
''

