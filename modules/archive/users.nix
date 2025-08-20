{ config, pkgs, age, ... }:

{

#  users.users.root = {
#    hashedPasswordFile = "/persist/persistence-security/hashedPasswordFile.txt";
#  };
#
#  #system.activationScripts.andrew_zshrc.text = '' touch /home/andrew/.zshrc '';
#  users.users.andrew = {
#    isNormalUser = true;
#    extraGroups = [ "wheel" "networkmanager" ];
#    hashedPasswordFile = "/persist/persistence-security/hashedPasswordFile.txt";
#
#  };

  # fileSystems."/home/andrew/.ssh" = {
  #   device = "/persist/persistence-ssh-andrew";
  #   options = [ "bind" ];
  # };

  # fileSystems."/root/.ssh" = {
  #   device = "/persist/persistence-ssh-root";
  #   options = [ "bind" ];
  # };

}

