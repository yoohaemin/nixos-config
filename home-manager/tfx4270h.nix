{ config, pkgs, ... }:
# let
#   unstable = import <unstable>{};
# in
{

  imports = [
    ./base.nix
    ./emacs.nix
    ./gnulinux.nix
    ./nixos.nix
    ./scala.nix
    ./shell.nix
    ./xmonad.nix
  ];

  # home.sessionVariables = {
  #   JAVA_HOME="/opt/graalvm-ee-java11-22.3.0";
  # };

  # home.packages = [
  #   unstable.google-chrome
  #   unstable.microsoft-edge
  #   unstable.slack
  # ];

  programs.git.userEmail = "haemin@zzz.pe.kr";
  home.stateVersion = "23.05";
}
