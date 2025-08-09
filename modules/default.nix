{ config, pkgs, lib, age, ... }:

{
  desktop-manager = "dwm";
  #desktop-manager = "retroarch";
  doas.enable     = true;
  git.enable      = true;
  zsh.enable      = true;

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
    ./qbittorrent.nix
    ./systemd-journal.nix
    ./systemd-recur-task.nix
    ./tailscale
    ./taskwarrior.nix
    ./tmux.nix
    ./users.nix
    ./virt-manager.nix
    ./zsh.nix
  ];

}

