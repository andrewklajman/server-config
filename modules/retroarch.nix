{ config, pkgs, lib, localLuks, ... }:

{
  options.retroarch.enable = lib.mkEnableOption "retroarch";

  config = lib.mkIf config.retroarch.enable {
    environment.systemPackages = [ 
      pkgs.retroarch
      # pkgs.retroarch-full
      pkgs.retroarch-joypad-autoconfig
    ];

  };

}

