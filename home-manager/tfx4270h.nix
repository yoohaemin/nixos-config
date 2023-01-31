{ config, pkgs, ... }:
{

  imports = [
    ./alacritty.nix
    ./base.nix
    ./emacs.nix
    ./gnulinux.nix
    ./nixos.nix
    ./scala.nix
    ./shell.nix
    ./xmonad.nix
  ];

  home.sessionVariables = {
    JAVA_HOME="/opt/graalvm-ee-java11-22.3.0";
  };

  programs.git.userEmail = "haemin@zzz.pe.kr";
  home.stateVersion = "22.05";
}
