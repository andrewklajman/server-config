# TODO : Backup function : Working on this now
# TODO : Native installation

{ config, pkgs, lib, ... }:

let 
  data_dir = config.password-manager.data_dir;
  backup_dir = config.password-manager.backup_dir;
in 
{
  options.password-manager = {
    enable = lib.mkEnableOption "password-manager";
    data_dir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/vaultwarden/data";
    };
    backup_dir = lib.mkOption {
      type = lib.types.str;
      default = "/mnt/vaultwarden/backups";
    };
  };

  config = lib.mkIf config.password-manager.enable { 
    environment.systemPackages = [ pkgs.gzip ];

    virtualisation.oci-containers.containers.vaultwarden = {
      image = "vaultwarden/server:latest";
      ports = [ "80:80" ];
      volumes = [ "${data_dir}:/data/" ];
    };


    systemd.services.vaultwarden-backup = {
      enable = true;
      wantedBy = [ "multi-user.target" ];
#      serviceConfig.Type = "oneshot";
#      after = [ "docker-vaultwarden.service" ];
      script = "${pkgs.writers.writeBash "vaultwarden-backup" ''
        ${pkgs.gnutar}/bin/tar cvf ${backup_dir}/vaultwarden.backup.$(${pkgs.coreutils}/bin/date +%F).tar ${config.password-manager.data_dir}
        ${pkgs.gzip}/bin/gzip ${backup_dir}/vaultwarden.backup.$(${pkgs.coreutils}/bin/date +%F).tar
      ''}";
    };

  };
 
# Linux pass
#    * https://github.com/emersion/webpass
#    * https://github.com/BenoitZugmeyer/pass-web
#    * https://github.com/cortex/ripasso : Is it possibel to serve gtk app  as a web service?

}

