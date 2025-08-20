{ config, lib, pkgs, localLuks, ... }:

let
  is_dwm = ( config.desktop-manager == "dwm" );
  module_dwm = (import ./dwm { inherit config lib pkgs localLuks; } );
in
{
  options.desktop-manager = lib.mkOption {
    type = lib.types.str;
    default = "dwm";
  };

  config = lib.mkMerge [ 
    (lib.mkIf is_dwm module_dwm)
  ];

}

