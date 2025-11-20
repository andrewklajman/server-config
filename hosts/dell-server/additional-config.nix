{ config, pkgs, lib, ... }:


{
  config = {
    nix.settings.experimental-features   = [ "nix-command" "flakes" ];

    basePackages.enable       = true;
    bootlimit.enable          = true;
    diskusage.enable          = true;
    doas.enable               = true;
    manPages.enable           = true;
    neovim.enable             = true;
    sessionVariables.enable   = true;
    zsh.enable                = true;

    services.openssh.enable = true;
    users.users.andrew = {
      openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGkquaq2kA7aXURJ0YNaK/E5jmlvrBPTmXoZWABmi0FA andrew@dell" ];  
    };

    programs.git = {
      enable = true;
      config = {
        safe.directory = [ "/root/server-config" ];
        user = {
          name  = [ "andrew" ];
          email = [ "andrew.klajman@gmail.com" ];
        };
      };
    };

  };

}

