{ config, pkgs, lib, ... }:
# https://nixalted.com/
# https://github.com/Gako358/neovim/blob/main/flake.nix

{

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    configure = {
      customRC = lib.fileContents ./init.vim;
      packages.myVimPackage = with pkgs.vimPlugins; {
        start = [ 
          catppuccin-nvim     # https://github.com/catppuccin/nvim/
        ];
        opt = [ ];
      }; 
    };
    withNodeJs = true;
  };

}
