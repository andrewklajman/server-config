{ config, pkgs, lib, ... }:

{
  options.zsh.enable = lib.mkEnableOption "zsh";
  config = lib.mkIf config.zsh.enable {
    users.defaultUserShell = pkgs.zsh;
    programs.zsh = {
      enable = true;
      enableCompletion = true;
      syntaxHighlighting.enable = true;
      autosuggestions.enable = true;
    };

    programs.zsh.interactiveShellInit = '' 
      bindkey '^ ' autosuggest-accept 
    '';

    programs.zsh.promptInit = ''
      zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
      zstyle ':completion:*' max-errors 1
      autoload -Uz compinit
      compinit
      HISTFILE=~/.histfile
      HISTSIZE=1000
      SAVEHIST=1000
      unsetopt beep
      bindkey -v
      bindkey '^ ' autosuggest-accept
    '';

    programs.zsh.shellAliases = {
      led     = "ledger -f main.txt --strict --pedantic --price-db prices.db --exchange $ --no-total";
      llol    = "ls -1 --group-directories-first";
      ll      = "ls -l --group-directories-first";
      lla     = "ls -al --group-directories-first";
      vi      = "nvim";
      vim     = "nvim";
      nr      = "nixos-rebuild switch --flake ./#pc";
      nrr     = "nixos-rebuild switch --flake ./#pc && reboot";
      nrl     = "doas git add . && doas nixos-rebuild switch --flake ./#lenovo";
      nrp     = "doas git add . && doas nixos-rebuild switch --flake ./#pc";
      ts      = "tailscale status";
      ms      = "mullvad status";
      mc      = "mullvad connect";
      md      = "mullvad disconnect";
      ss      = "systemctl status";
      sr      = "systemctl restart";
      j       = "journalctl -xeu";
      envrust = "nix-shell -A rust ${config.consts.localPersist.mountPoint}/server-config/shells";
    };
  };
}
