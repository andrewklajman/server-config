{ config, lib, pkgs, ... }:

let 
  persist = "/mnt/localPersist";
  settings = "/mnt/localPersist/persistence";
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
    networking.hostName            = "dell";

    dwm-enhanced.enable            = true;
    audiobookshelf.enable          = true;

    users.hashedPasswordFile       = "${persist}/persistence/andrew/hashedPasswordFile";
    networkmanager.config          = "${persist}/persistence/system/system-connections";

    fileSystems = {
      "/home/andrew/server-config" = bindMount "${persist}/server-config";
      "/home/andrew/rust"          = bindMount "${persist}/rust";

      "/home/andrew/.zshrc"        = bindMount "${persist}/persistence/andrew/zshrc";
      "/home/andrew/.ssh"          = bindMount "${persist}/persistence/andrew/ssh";
      "/root/.ssh"                 = bindMount "${persist}/persistence/root/ssh";
    };

    personal-security = {
      enable                       = true;
      gnupgHome                    = "${persist}/persistence/apps/gnupg";
      passwordStoreDir             = "${persist}/persistence/apps/password-store";
    };

    mullvad = {
      configDir                    = "${persist}/persistence/apps/mullvad/";
    };

    open-notes = {
      enable                       = true;
      DirNotes                     = "/home/andrew/luks/critical/open_notes/notes";
      DirTags                      = "/home/andrew/luks/critical/open_notes/tags";
    };

    taskwarrior = {
      enable                       = true;
      taskrc                       = "/home/andrew/luks/Documents/taskwarrior/taskrc";
      taskdata                     = "/home/andrew/luks/Documents/taskwarrior/taskdata";
    };

  	programs.git = {
  	  config = {
  	    safe.directory = [ 
  	      "${persist}/server-config" 
  	      "/home/andrew/server-config" 
  	    ];
  	    user = {
          name  = [ "andrew" ];
  	      email = [ "andrew.klajman@gmail.com" ];
        };
  	  };
  	};

    qbittorrent-client.enable = true;
    calibre.enable           = true;

  };
}
