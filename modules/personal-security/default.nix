{ config, pkgs, lib, ... }:

let 
  passmenulogin = pkgs.writeShellScriptBin "passmenulogin" '' ${builtins.readFile ./passmenulogin} '';
  passwebsite = pkgs.writeShellScriptBin "passwebsite" '' ${builtins.readFile ./passwebsite} '';
in
{
  options.personal-security = {
    enable = lib.mkEnableOption "personal-security";
    gnupgHome = lib.mkOption { type = lib.types.str; };
    passwordStoreDir = lib.mkOption { type = lib.types.str; };
  };

  config = lib.mkIf config.personal-security.enable {

    programs.gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-qt;
    };

    environment = {
      systemPackages = with pkgs; [ 
        pass 
        passmenulogin 
        passwebsite
      ];
      variables = {
        GNUPGHOME = config.personal-security.gnupgHome;
        PASSWORD_STORE_DIR = config.personal-security.passwordStoreDir;
      };
    };

  };

}

