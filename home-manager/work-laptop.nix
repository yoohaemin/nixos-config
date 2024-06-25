{ config, pkgs, ... }:
{

  imports = [
    ./base.nix
    ./emacs.nix
    ./macos.nix
    ./private.nix
    ./scala.nix
    ./shell.nix
  ];

  programs.git.userEmail = "haemin@smartpay.co";
  home.stateVersion = "22.05";
}
