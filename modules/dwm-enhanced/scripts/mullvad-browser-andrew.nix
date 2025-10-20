{ config, pkgs }:

let 
  localLuks = config.consts.localLuks;
in

pkgs.writeShellScriptBin "mullvad-browser-andrew" '' 
  mullvad-browser --profile ${localLuks.mountPoint}/mullvad-profiles/andrew
''

