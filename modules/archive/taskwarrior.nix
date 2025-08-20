{ config, pkgs, lib, ... }:
let 
  twe = pkgs.writeShellScriptBin "twe" '' task_id=$(task add "$@" project:health.exercise | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done '';
  twl = pkgs.writeShellScriptBin "twl" '' task_id=$(task add "$@" project:health.log | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done '';
  twlp = pkgs.writeShellScriptBin "twlp" '' task_id=$(task add "$@" project:health.log | cut -d' ' -f3 | cut -d'.' -f1) +private; task $task_id done '';
  twd = pkgs.writeShellScriptBin "twd" '' task_id=$(task add "$@" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done '';
  twdps = pkgs.writeShellScriptBin "twdps" '' task_id=$(twd "240 Protein Shake" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  twdpos = pkgs.writeShellScriptBin "twdpos" '' task_id=$(twd "500 Protein Olive Oil Shake" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  twdpms = pkgs.writeShellScriptBin "twdpms" '' task_id=$(twd "300 Protein Morning Shake" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  twdc = pkgs.writeShellScriptBin "twdc" '' task_id=$(twd "0 Black coffee" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  twdy = pkgs.writeShellScriptBin "twdy" '' task_id=$(twd "50 Yakult lite" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  twdyo = pkgs.writeShellScriptBin "twdyo" '' task_id=$(twd "700 Yakult lite w olive oil" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  twdyho = pkgs.writeShellScriptBin "twdyho" '' task_id=$(twd "380 Yakult lite w half olive oil" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  twdk = pkgs.writeShellScriptBin "twdk" '' task_id=$(twd "0 Kombucha" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  twda = pkgs.writeShellScriptBin "twda" '' task_id=$(twd "50 Apple" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  twdw = pkgs.writeShellScriptBin "twdw" '' task_id=$(twd "0 Water" project:health.diet | cut -d' ' -f3 | cut -d'.' -f1); task $task_id done ''; 
  journal = pkgs.writeShellScriptBin "journal" '' bash /home/andrew/Documents/notes/scripts/jw.sh''; 
  exercise = pkgs.writeShellScriptBin "exercise" '' bash /home/andrew/Documents/notes/scripts/exercise.sh''; 
in
{
  options.taskwarrior.enable = lib.mkEnableOption "taskwarrior";

  config = lib.mkIf config.taskwarrior.enable {
    # Packages
    environment.systemPackages = with pkgs; [ 
      taskwarrior3 
        twd twda twdc twdk twdps twdpms twdpos twdw twdy twdyo twdyho
        twe twl twlp
      journal exercise
    ];
  };
}

