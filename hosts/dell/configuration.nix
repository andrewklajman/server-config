{ config, lib, pkgs, ... }:

let 
  persist = "/mnt/localPersist";
  bindMount = device: {
    inherit device;
    options = [ "bind" ];
  };
in
{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules
  ];

  options.consts = lib.mkOption {
    type = lib.types.attrs;
    readOnly = true;
    default = {
      localLuks = {
        device     = "/dev/nvme0n1p4";
        mapperName = "persist-enc";
        mountPoint = "/mnt/localLuks";
      };
    };
  };

  config = {
    basePackages.enable                  = true;
    bootlimit.enable                     = true;
    diskusage.enable                     = true;
    doas.enable                          = true;
    manPages.enable                      = true;
    neovim.enable                        = true;
    sessionVariables.enable              = true;
    zsh.enable                           = true;

    time.timeZone                        = "Australia/Sydney";
    nixpkgs.config.allowUnfree           = true;
    nix.settings.experimental-features   = [ "nix-command" "flakes" ];
    boot.loader.systemd-boot.enable      = true;
    boot.loader.efi.canTouchEfiVariables = true;
    system.stateVersion                  = "25.05"; 




    dwm-enhanced.enable                 = true;
    networking = {
      hostName                 = "dell";
      firewall.allowedTCPPorts = [ 80 443 ];
      networkmanager.enable = true; 
    };
    pipewire.enable                     = true;
    users.enable                        = true;
    udev-samsung-portable-ssd.enable    = true;
    qbittorrent-client.enable           = true;
    users.hashedPasswordFile            = "${persist}/persistence/andrew/hashedPasswordFile";

    fileSystems = {
      "/home/andrew/server-config"             = bindMount "${persist}/server-config";
      "/home/andrew/rust"                      = bindMount "${persist}/rust";

      "/home/andrew/.zshrc"                    = bindMount "${persist}/persistence/andrew/zshrc";
      "/home/andrew/.ssh"                      = bindMount "${persist}/persistence/andrew/ssh";
      "/root/.ssh"                             = bindMount "${persist}/persistence/root/ssh";
      "/etc/NetworkManager/system-connections" = bindMount "${persist}/persistence/system/system-connections";
    };

  	programs.git = {
      enable = true;
  	  config = {
  	    safe.directory = [ 
  	      "${persist}/server-config" 
  	      "/home/andrew/server-config" 
  	    ];
  	    user = {
          name = [ "andrew" ];
  	      email = [ "andrew.klajman@gmail.com" ];
        };
  	  };
  	};

    mullvad = {
      enable = true;
      configDir = "${persist}/persistence/apps/mullvad/";
    };

    tailscale-userspace = {
      enable = true;
      configDir = "/mnt/localPersist/tailscale";
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
    };

    personal-security = {
      enable = true;
      gnupgHome = "${persist}/persistence/apps/gnupg";
      passwordStoreDir = "${persist}/persistence/apps/password-store";
    };

    open-notes = {
      enable = true;
      DirNotes = "/home/andrew/luks/critical/open_notes/notes";
      DirTags = "/home/andrew/luks/critical/open_notes/tags";
    };

    taskwarrior = {
      enable = true;
      taskrc = "/home/andrew/luks/Documents/taskwarrior/taskrc";
      taskdata = "/home/andrew/luks/Documents/taskwarrior/taskdata";
    };

  };
}
