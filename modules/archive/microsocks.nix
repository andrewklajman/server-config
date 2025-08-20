{ config, pkgs, lib, ... }:

{
  options.microsocks = {
    enable = lib.mkEnableOption "microsocks";
    port = lib.mkOption {
      type = lib.types.ints.unsigned;
      default = 8888;
    };
  };

  config = lib.mkIf config.microsocks.enable  {
    services.microsocks = {
      enable = true;
      port = config.microsocks.port;
      user = "microsocks";
    };

  };
}
