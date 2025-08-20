{ config, pkgs, lib, age, ... }:

{
  options.agenix.enable = lib.mkEnableOption "agenix";

  config = lib.mkIf config.agenix.enable {
    age.identityPaths = [ "/persist/ssh-andrew/id_ed25519" ];
    age.secrets.Optus_C99CB5.file = ./Optus_C99CB5.age;
  };
}
