{ config, pkgs, lib, ... }:

let
  cfg = config.cloudflare-abs;
in
{
  options.cloudflare-abs = {
    enable = lib.mkEnableOption "cloudflare-abs";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [ cloudflared ];

 # --- Cloudflared --- #
     services.cloudflared = {
       enable = true;
       tunnels = {
         "klajman_xyz" = {
           credentialsFile = "/root/.cloudflared/95694a32-70f1-4bd6-bdf0-74e07fa4b76a.json";
           default = "http_status:404";
           ingress = {
             "klajman.xyz" = "http://localhost";
             "abs.klajman.xyz" = "http://localhost";
           };
         };
       };
     };

# --- Audiobookshelf --- #
    services.audiobookshelf = {
      enable = true;
      openFirewall = true;
      host = "0.0.0.0";
    };

# --- Nginx Reverse Proxy --- #
    services.nginx = {
      enable = true;
      #config = builtins.readFile ./cloudflare-abs.nginx.conf;

# --- Cloudflare Nginx --- #
# events { worker_connections  1024; }
# 
# http {
# 
#   server { 
#     listen 80; listen [::]:80; 
#     server_name klajman.xyz;
#     location / { 
#       auth_basic           "Authentication"; #admin, admin
#       auth_basic_user_file /www/auth/htpasswd;
#       root /www/site; 
#     } 
#   }
# 
#   server { 
#     listen 80; listen [::]:80; 
#     server_name abs.klajman.xyz;
#       location / { 
# # basic_auth will not work with websockets making it incompatible with abs
# #      auth_basic           "Authentication"; #admin, admin
# #      auth_basic_user_file /www/auth/htpasswd;
# 
#         proxy_pass http://127.0.0.1:8000;
#         proxy_http_version  1.1;
#         proxy_cache_bypass  $http_upgrade;
#         proxy_set_header Upgrade           $http_upgrade;
#         proxy_set_header Connection        "upgrade";
#         proxy_read_timeout                 86400;
#         proxy_set_header Host              $host;
#         proxy_set_header X-Real-IP         $remote_addr;
#         proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto $scheme;
#         proxy_set_header X-Forwarded-Host  $host;
#         proxy_set_header X-Forwarded-Port  $server_port;
#       }
#   }
# }





    };

  };
}
