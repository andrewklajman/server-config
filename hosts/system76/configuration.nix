{ config, lib, pkgs, ... }:

let 
  mp = config.consts.localPersist.mountPoint;
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
      nm_config = "/mnt/persist/config/system-connections";
    };
  };

  config = {
    dwm-basic.enable       = true;

    networking = {
      NetworkManager = {
        enable = true;
        config = "${config.consts.nm_config}";
      };
      openssh = {
        enable = true;
      	sshKey = {
      	  device = "/mnt/persist/config/ssh-andrew";
      	  mountPoint = "/home/andrew/.ssh";
      	};
        authKeyFile = {
          device = "/mnt/persist/config/ssh-andrew-authorized-keys";
      	  mountPoint = "/home/andrew/.ssh/authorized_keys";
        };
      };
    };


# Users
    users.users.root.initialPassword = "pass";
    users.users.andrew = {
      isNormalUser = true;
      extraGroups = [ "wheel" ]; 
      initialPassword = "pass";
    };

    environment.systemPackages = with pkgs; [
      vim 
      wget
      git 
    ];

  # Doas
    security.sudo.enable = false;
    security.doas = {
      enable = true;
      extraRules = [
        {
          users = ["andrew"];
          keepEnv = true; 
          persist = true;
        }
      ];
    };
  
  # Timezone
    time.timeZone = "Australia/Sydney";

    system.stateVersion = "25.05"; 
    boot.loader.grub.enable = true;
    boot.loader.grub.device = "/dev/sda"; 
  };
}

