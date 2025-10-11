{ config, lib, pkgs, ... }:

let 
  mp = "/mnt/localPersist";
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
    networking.hostName      = "dell";

    networking.firewall = {
      enable = true;
      allowedTCPPorts = [ 8000 ];
    };

    dwm-enhanced.enable      = true;
    users.hashedPasswordFile = "${settings}/andrew/hashedPasswordFile";
    networkmanager.config    = "${settings}/system/system-connections";
    personal-security.enable = true;

    fileSystems = {
      "/home/andrew/server-config" = bindMount "${mp}/server-config";
      "/home/andrew/rust"          = bindMount "${mp}/rust";

      "/home/andrew/.zshrc"        = bindMount "${settings}/andrew/zshrc";
      "/home/andrew/.ssh"          = bindMount "${settings}/andrew/ssh";
      "/root/.ssh"                 = bindMount "${settings}/root/ssh";
    };

    personal-security = {
      gnupgHome        = "${settings}/apps/gnupg";
      passwordStoreDir = "${settings}/apps/password-store";
    };

    mullvad = {
      configDir = "${settings}/apps/mullvad/";
    };

  	programs.git = {
  	  config = {
  	    safe.directory = [ 
  	      "${mp}/server-config" 
  	      "/home/andrew/server-config" 
  	    ];
  	    user.name  = [ "andrew" ];
  	    user.email = [ "andrew.klajman@gmail.com" ];
  	  };
  	};

    taskwarrior.enable       = true;
    qbittorrent-client.enable = true;

#    calibre.enable           = false;
#    bluetooth.enable         = true;
#    personal-security.enable = true;
#    audiobookshelf = {
#      enable = false;
#      dataDir = "/home/andrew";
#      port = 8081;
#    };

  };
}
