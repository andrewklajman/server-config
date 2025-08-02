{ config, lib, pkgs, ... }:

let
  is_dwm = ( config.desktop-manager == "dwm" );
  is_gnome = ( config.desktop-manager == "gnome" );
  module_dwm = (import ./dwm { inherit config lib pkgs; } );
  module_gnome = (import ./gnome.nix { inherit config lib pkgs; } );
in
{
  options.desktop-manager = lib.mkOption {
    type = lib.types.str;
    default = "dwm";
  };
  config = lib.mkMerge [ (lib.mkIf is_dwm module_dwm)
                         (lib.mkIf is_gnome module_gnome) ];
}

