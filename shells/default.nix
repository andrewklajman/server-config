# https://www.reddit.com/r/NixOS/comments/1m2kp4s/how_to_specify_zshrc_when_running_via_nixshell/
let
  pkgs = import <nixpkgs> { };
  python = pkgs.mkShell {
    packages = [
      (pkgs.python3.withPackages (python-pkgs: [
        python-pkgs.beautifulsoup4
        python-pkgs.matplotlib
        python-pkgs.pandas
        python-pkgs.pygame
        python-pkgs.requests
        python-pkgs.selenium
        python-pkgs.yfinance 
        python-pkgs.curl-cffi
      ]))
    ];
  };
  rust = pkgs.mkShell {
    packages = [ pkgs.cargo pkgs.rustc ];
    shellHook = '' 
      PS1="[rust] " 
      alias ccr="clear; RUSTFLAGS=-Awarnings cargo run;"
      alias entrust="echo src/main.rs | entr -cs 'cargo run'"
    '';
  };

in
{
  inherit 
    python 
    rust;
}
  
