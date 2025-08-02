{ config, pkgs, ... }:

{
  environment.persistence."/persist/persistence-module" = {
    enable = true;
    hideMounts = false;
    directories = [
      "/etc/NetworkManager/system-connections"
    ];
  };
}

# environment.etc."NetworkManager/system-connections/Optus_C99CB5.nmconnection" = {
#   source = config.age.secrets.Optus_C99CB5.path;
# };
#  environment.etc."NetworkManager/system-connections" = {
#    source = "/persist/system-connections/";
#  };
# environment.etc."NetworkManager/system-connections/Optus_C99CB5.nmconnection" = {
#   source = "${Optus_C99CB5_nmconnection}";
# };
#let Optus_C99CB5_nmconnection = pkgs.stdenv.mkDerivation {
#    name = "OptusC99CB5.nmconnection";
#    src = pkgs.writeText "OptusC99CB5.nmconnection" '' 
#      [connection]
#      id=Optus_C99CB5
#      uuid=5fb5ac4b-6d33-491e-a8b6-8952714ddfc1
#      type=wifi
#      interface-name=wlp0s20f3
#      
#      [wifi]
#      mode=infrastructure
#      ssid=Optus_C99CB5
#      
#      [wifi-security]
#      auth-alg=open
#      key-mgmt=wpa-psk
#      psk=53a5e6f9fb89369bd950b0c61a42a34d4a1918e778145520602182ebce109f6b
#      
#      [ipv4]
#      method=auto
#      
#      [ipv6]
#      addr-gen-mode=default
#      method=auto
#      
#      [proxy]
#    '';
#    installPhase = ''
#      mkdir $out
#      cp $src $out/Optus_C99CB5.nmconnection
#      chmod 600 $out/Optus_C99CB5.nmconnection
#      chown root:root $out/Optus_C99CB5.nmconnection
#    '';
#    unpackPhase = '' '';
#  };
#in
