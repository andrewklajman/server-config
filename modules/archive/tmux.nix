{ config, pkgs, lib, ... }:

{
  options.tmux.enable = lib.mkEnableOption "tmux";
  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      shortcut = "a";
      keyMode = "vi";
      customPaneNavigationAndResize = true;
    };
  };
}
