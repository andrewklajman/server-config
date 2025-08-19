{ config, pkgs, lib, age, ... }:

{
  desktop-manager = "dwm";
  doas.enable     = true;
  zsh.enable      = true;

  services.calibre-server = {
    enable = true;
    libraries = [ "/storage/encrypted-luks/calibre" ];
  };

  imports = [
    ./audiobookshelf.nix
    ./calibre.nix
    ./desktop-environment
    ./doas.nix
    ./docker.nix
    ./environment.nix
    ./git.nix
    ./metube.nix
    ./microsocks.nix
    ./mullvad
    ./neovim.nix
    ./password-manager.nix
    ./personal-security
    ./retroarch.nix
    ./systemd-journal.nix
    ./systemd-recur-task.nix
    ./tailscale
    ./taskwarrior.nix
    ./tmux.nix
    ./torrent.nix
    ./users.nix
    ./virt-manager.nix
    ./zsh.nix
  ];

}

