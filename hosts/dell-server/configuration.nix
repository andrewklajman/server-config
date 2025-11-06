{ config, lib, pkgs, ... }:

{


  imports = [ 
    ./hardware-configuration.nix
    ../../modules
  ];

  config = {
    networking.hostName            = "dell-server";

    #audiobookshelf.enable          = true;

  	#programs.git = {
  	#  config = {
  	#    safe.directory = [ 
  	#      "${persist}/server-config" 
  	#      "/home/andrew/server-config" 
  	#    ];
  	#    user = {
    #      name  = [ "andrew" ];
  	#      email = [ "andrew.klajman@gmail.com" ];
    #    };
  	#  };
  	#};

  };
}
