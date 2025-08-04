{ config, pkgs, lib, age, ... }:
{
  imports = [
#    ./agenix
    ./audiobookshelf.nix
    ./calibre.nix
    ./desktop-environment
    ./doas.nix
    ./docker.nix
    ./environment.nix
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

